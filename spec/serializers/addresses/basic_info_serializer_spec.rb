# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Addresses::BasicInfoSerializer do
  let(:address) { create(:address, :for_user) }

  describe '#serialize_to_json' do
    subject { described_class.new.serialize(address).deep_symbolize_keys! }

    it {
      is_expected.to eql(
        city: address.city,
        state: address.state,
        country: address.country,
        address_line: address.address_line,
        zip_code: zip_code,
        coordinates: coordinates
      )
    }

    def coordinates
      { latitude: address.latitude, longitude: address.longitude }
    end

    def zip_code
      zipcode&.code
    end

    def zipcode
      @zipcode ||= ZipCode.find_by(id: address.zip_code_id)
    end
  end
end
