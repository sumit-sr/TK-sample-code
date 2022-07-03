# frozen_string_literal: true

module BraintreeResponses
  def credit_card_response
    OpenStruct.new(
      success?: true,
      credit_card: credit_card_payload
    )
  end

  def escrow_transaction_response
    OpenStruct.new(
      success?: true,
      transaction: OpenStruct.new(
        id: '456',
        status: 'success'
      )
    )
  end

  def credit_card_payload
    OpenStruct.new(
      token: '12345678',
      card_type: 'visa',
      verification: verification_payload,
      billing_address: OpenStruct.new(
        id: '456'
      )
    )
  end

  def verification_payload
    OpenStruct.new(
      id: '123',
      status: 'verified'
    )
  end

  def webhook_payload
    OpenStruct.new(
      gateway: {},
      kind: 'check',
      subject: { check: true },
      timestamp: DateTime.now
    )
  end
end
