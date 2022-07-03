# frozen_string_literal: true

# Calss for making opayment via Braintree

module Gateways
  class BraintreePayment
    require 'rubygems'
    require 'braintree'

    include Gateways::Braintree::Account
    include Gateways::Braintree::Address
    include Gateways::Braintree::CreditCard
    include Gateways::Braintree::Customer
    include Gateways::Braintree::Transaction
    include Gateways::Braintree::Webhook

    def initialize(user: nil, data: {}, extra_data: {})
      @braintree = Setting.where(
        slug: 'braintree', environment_id: Rails.env
      ).first
      @user = user
      @data = data
      @extra_data = extra_data
      @gateway = set_braintree_gateway
    end

    def add_card
      card
    end

    def set_braintree_gateway
      ::Braintree::Gateway.new(
        environment: @braintree.preferences[:environment],
        merchant_id: @braintree.preferences[:merchant_id],
        public_key: @braintree.preferences[:public_key],
        private_key: @braintree.preferences[:private_key]
      )
    end
  end
end
