# frozen_string_literal: true

# NOTE: we can make this class but first we need to decide how input/output
## is going to be for now using as module

module Gateways
  module Braintree
    module CreditCard
      def card
        if card_exist?
          return OpenStruct.new(
            success?: false,
            errors: ['Card already exist for this user']
          )
        end

        @gateway.credit_card.create(card_params)
      end

      def update_card
        @gateway.credit_card.update(@data.token, card_update_params)
      end

      def delete_card
        @gateway.credit_card.delete(@data.token)
      end

      private

      def card_update_params
        update_params = card_details
        update_params.delete(:number)
        update_params
      end

      def card_params
        @card_details = card_details
        @card_details[:billing_address] = billing_address if @data.address&.zip_code.present?
        @card_details[:customer_id] = @user.customer_id
        @card_details
      end

      def card_details
        {
          cardholder_name: @data[:name],
          number: @extra_data[:number],
          expiration_date: "#{@data[:month]}/#{@data[:year]}",
          cvv: @extra_data[:cvv],
          options: { verify_card: true }
        }
      end

      def card_exist?
        collection = @gateway.verification.search do |search|
          search.customer_id.is @user.customer_id
          search.credit_card_number.is @extra_data[:number]
        end
        ::CreditCard.where(
          user_id: @user.id,
          verification_id: collection.ids
        ).exists?
      end
    end
  end
end
