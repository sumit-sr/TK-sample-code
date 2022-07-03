# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::BasicSerializer do
  let(:task) { create(:task) }

  describe '#serialize_to_json' do
    subject { described_class.new.serialize(task).deep_symbolize_keys! }

    it {
      is_expected.to eql(
        id: task.id,
        title: task.title
      )
    }
  end
end
