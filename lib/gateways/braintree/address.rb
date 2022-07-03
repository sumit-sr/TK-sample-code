# frozen_string_literal: true

module Gateways
  module Braintree
    module Address
      def billing_address
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
  end
end
