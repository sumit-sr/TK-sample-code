# frozen_string_literal: true

# Class for making payment via Stripe

module Gateways
  class StripePayment
    require 'stripe'

    def initialize(user = nil, data = {}, extra_data = {})
      @stripe = Setting.where(slug: 'stripe', environment_id: Rails.env).first
      set_stripe_gateway
      @user = user
      @data = data
      @extra_data = extra_data
    end

    def add_customer
      @customer ||= Stripe::Customer.create(
        name: "#{@user.first_name} #{@user.last_name}",
        email: @user.email
      )
    rescue StandardError => e
      { errors: e }
    end

    def sub_merchant
      Stripe::Customer.create_source(
        @user.customer_id,
        source: source
      )
    end

    def source
      {
        object: 'bank_account',
        country: 'IN',
        currency: 'INR',
        account_number: @data.account_number,
        account_holder_name: @data.account_holder_name,
        account_holder_type: 'individual',
        routing_number: @data.routing_number
      }
    end

    def set_stripe_gateway
      Stripe.api_key = @stripe.preferences[:secret_key]
    end

    def list_customers
      Stripe::Customer.list(limit: 3)
    end
  end
end
