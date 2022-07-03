# frozen_string_literal: true

module Gateways
  module Braintree
    module Webhook
      def webhook_parse(params)
        @gateway.webhook_notification.parse(
          params['bt_signature'],
          params['bt_payload']
        )
      end
    end
  end
end
