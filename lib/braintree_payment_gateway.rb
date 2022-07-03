# frozen_string_literal: true

class BraintreePaymentGateway
  require 'rubygems'
  require 'braintree'

  def initialize(user = nil, data = {}, extra_data = {})
    @braintree = Setting.where(slug: 'braintree', environment_id: Rails.env).first
    @user = user
    @data = data
    @extra_data = extra_data
    @gateway = set_braintree_gateway
  end

  def add_customer
    @gateway.customer.create(
      first_name: @user.first_name,
      last_name: @user.last_name,
      email: @user.email
    )
  end

  def add_card
    set_card_details
    set_billing_address

    @card_details = @card_details.merge(billing_address: @billing_address) if @data.address&.zip_code.present?

    @gateway.credit_card.create(@card_details.merge(customer_id: @user.customer_id))
  end

  def update_card
    set_card_details
    set_billing_address

    @card_details = if address_modified?
                      @card_details.merge(billing_address: @billing_address)
                    else
                      @card_details.merge(billing_address_id: @data.billing_address_id)
                    end

    @gateway.credit_card.update(@data.token, @card_details)
  end

  def delete_card
    @gateway.credit_card.delete(@data.token)
  end

  def verify_card
    @gateway.verification.search do |search|
      search.id.is @data.verification_id
    end
  end

  def create_escrow_transaction
    @gateway.transaction.sale(
      merchant_account_id: @data.bank_account&.merchant_id,
      amount: @data.amount,
      payment_method_nonce: payment_method_nounce,
      service_fee_amount: @data.fee,
      options: {
        hold_in_escrow: true
      }
    )
  end

  def create_transaction
    @gateway.transaction.sale(
      merchant_account_id: @data.bank_account&.merchant_id,
      amount: @data.amount,
      payment_method_nonce: payment_method_nounce,
      service_fee_amount: @data.fee,
      options: {
        submit_for_settlement: true
      }
    )
  end

  def payment_method_nounce
    result = @gateway.payment_method_nonce.create(@data.credit_card.token)
    result.payment_method_nonce.nonce
  end

  # Escrow Services

  def hold_in_escrow
    @gateway.transaction.hold_in_escrow(@data.transaction_id)
  end

  def cancel_excrow_release
    @gateway.transaction.cancel_release(@data.transaction_id)
  end

  def refund
    @gateway.transaction.refund(@data.transaction_id)
  end

  def void
    @gateway.transaction.void(@data.transaction_id)
  end

  # Non action methods
  def set_braintree_gateway
    Braintree::Gateway.new(
      environment: @braintree.preferences[:environment],
      merchant_id: @braintree.preferences[:merchant_id],
      public_key: @braintree.preferences[:public_key],
      private_key: @braintree.preferences[:private_key]
    )
  end

  def address_modified?
    @data.address.name_changed? || @data.address.address_line_changed? ||
      @data.address.zip_code_id_changed?
  end

  def set_card_details
    @card_details = { cardholder_name: @data[:name],
                      number: @extra_data[:number],
                      expiration_date: "#{@data[:month]}/#{@data[:year]}",
                      cvv: @extra_data[:cvv],
                      options: { verify_card: true } }
  end

  def set_billing_address
    @billing_address = assign_data
  end

  def assign_data
    return nil if @data.address.blank?

    address = @data.address
    {
      street_address: address.name,
      extended_address: address.address_line,
      locality: address.zip_code&.city&.name,
      region: address.zip_code&.state&.prefix,
      postal_code: address.zip_code&.code
    }
  end
end
