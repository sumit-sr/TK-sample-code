# frozen_string_literal: true

require 'rails_helper'

class TestPanko < Panko::Serializer
  attributes(
    :id,
    :first_name,
    :last_name
  )
end

RSpec.describe PankoResponse do
  let(:records) { User.all }
  let(:serializer) { TestPanko }
  let(:attributes) do
    {
      collection: records,
      serializer: serializer
    }
  end

  let(:expected_results) do
    Panko::ArraySerializer.new(
      expected_records,
      each_serializer: serializer
    )
  end

  before(:example) do
    create_list(:user, number_of_records)
  end

  describe '#response' do
    let(:subject) do
      described_class.new(
        collection: records,
        serializer: serializer
      ).response.to_json
    end

    context 'when there are no records' do
      let(:number_of_records) { 0 }

      it { is_expected.to eql('{}') }
    end

    context 'when there are two records' do
      let(:number_of_records) { 2 }
      let(:expected_records) { records }

      it do
        is_expected.to eql(
          Panko::Response.new(
            result: expected_results
          ).to_json
        )
      end
    end
  end
end
