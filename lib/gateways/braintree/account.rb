# frozen_string_literal: true

module Gateways
  module Braintree
    module Account
      def create_account
        merchant_account_params.merge!(master_merchant_detail)
        @gateway.merchant_account.create(merchant_account_params)
      end

      def update_account
        merchant_account_params[:funding].delete(:account_number)

        @gateway.merchant_account.update(
          @data.merchant_id, merchant_account_params
        )
      end

      def merchant_account_params
        @merchant_account_params ||= {
          individual: individual_detail,
          funding: funding_detail
        }
      end

      def individual_detail
        {
          first_name: first_name,
          last_name: last_name,
          email: @user.email,
          date_of_birth: @user&.dob,
          address: {
            street_address: @user.default_address.address_line
          }.merge(individual_account_address)
        }
      end

      def individual_account_address
        {
          locality: zip_code&.city&.name,
          region: zip_code&.city&.state&.prefix,
          postal_code: zip_code&.code
        }
      end

      def funding_detail
        {
          destination: ::Braintree::MerchantAccount::FundingDestination::Bank,
          account_number: @data.account_number,
          routing_number: @data.routing_number
        }
      end

      def master_merchant_detail
        {
          master_merchant_account_id: master_merchant_id,
          tos_accepted: true
        }
      end

      def master_merchant_id
        @master_merchant_id ||= @braintree.preferences[:master_merchant_id]
      end

      def zip_code
        @zip_code ||= @user.default_address.zip_code
      end

      def first_name
        splited_name.first
      end

      def last_name
        splited_name.delete(first_name)
        splited_name.join(' ')
      end

      def splited_name
        @splited_name ||= @data.account_holder_name.split
      end
    end
  end
end
