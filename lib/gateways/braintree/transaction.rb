# frozen_string_literal: true

module Gateways
  module Braintree
    module Transaction
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

      def create_direct_transaction
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

      def track_transaction
        @gateway.transaction.find(@data.transaction_id)
      end

      def hold_in_escrow
        @gateway.transaction.hold_in_escrow(@data.transaction_id)
      end

      def release_from_escrow
        @gateway.transaction.release_from_escrow(@data.transaction_id)
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
    end
  end
end
