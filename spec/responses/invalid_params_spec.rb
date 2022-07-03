# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvalidParams do
  let(:exception) { 'any exception' }

  subject { described_class.new(exception).response }

  it do
    is_expected.to eql(
      status: :bad_request,
      json: { errors: [exception] }
    )
  end
end
