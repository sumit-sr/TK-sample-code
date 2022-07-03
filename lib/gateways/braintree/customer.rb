# frozen_string_literal: true

module Gateways
  module Braintree
    module Customer
      def add_customer
        return customer unless customer.success?

        customer&.customer
      end

      def customer
        @customer ||= @gateway.customer.create(
          first_name: @user.first_name,
          last_name: @user.last_name,
          email: @user.email
        )
      end
    end
  end
end
