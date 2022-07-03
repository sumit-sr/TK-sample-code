# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address do
  context 'Associations' do
    it { is_expected.to belong_to(:addressable) }
    it { is_expected.to belong_to(:zip_code).optional(true) }
  end

  context 'Validations' do
    # it { is_expected.to validate_presence_of(:zip_code_id) }
  end

  context 'FactoryBot' do
    # let(:address) { create(:address, :for_user) }

    # it 'can create an address factory for a user' do
    #   expect(address.valid?).to be(true)
    # end
  end
end
