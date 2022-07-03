# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InfoSerializer do
  let(:user) { create(:user) }

  describe '#serialize_to_json' do
    subject { described_class.new.serialize(user).deep_symbolize_keys! }

    it {
      is_expected.to eql(
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        profile_pic: user.profile_pic,
        profile_pic_alt: user.profile_pic_alt,
        rating_as_a_poster: user.rating_as_a_poster
      )
    }
  end
end
