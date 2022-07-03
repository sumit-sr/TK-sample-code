# frozen_string_literal: true

require 'rails_helper'

class TestPanko < Panko::Serializer
  attributes(
    :id,
    :first_name,
    :last_name
  )
end

class TestContext < Panko::Serializer
  attributes(
    :context_fetch
  )

  def context_fetch
    context[:value]
  end
end

RSpec.describe PankoPaginatedResponse do
  let(:page) { 1 }
  let(:records) { User.all }
  let(:serializer) { TestPanko }
  let(:options) { {} }
  let(:attributes) do
    {
      page: page,
      per_page: per_page,
      collection: records,
      serializer: serializer,
      options: options
    }
  end

  let(:expected_results) do
    Panko::ArraySerializer.new(
      expected_records,
      each_serializer: serializer,
      context: options[:context]
    )
  end
  let(:before_request) do
    User.all.destroy_all
  end

  before(:example) do
    before_request
    create_list(:user, number_of_records)
  end

  describe '#response' do
    let(:subject) do
      described_class.new(
        page: page,
        per_page: per_page,
        collection: records,
        serializer: serializer,
        options: options
      ).response.to_json
    end

    context 'when there are no records' do
      let(:per_page) { 4 }
      let(:number_of_records) { 0 }
      let(:expected_records) { [] }

      it do
        is_expected.to eql(
          Panko::Response.new(
            page: page,
            limit: per_page,
            total: number_of_records,
            result: expected_results
          ).to_json
        )
      end
    end

    context 'when number of records is less than one page' do
      let(:number_of_records) { 2 }
      let(:per_page) { 4 }
      let(:expected_records) { records }

      it do
        is_expected.to eql(
          Panko::Response.new(
            page: 1,
            limit: per_page,
            total: number_of_records,
            result: expected_results
          ).to_json
        )
      end
    end

    context 'when number of records is more than one page' do
      let(:number_of_records) { 10 }
      let(:per_page) { 4 }

      context 'when page is one' do
        let(:expected_records) { records.limit(per_page) }

        it do
          is_expected.to eql(
            Panko::Response.new(
              page: page,
              limit: per_page,
              total: number_of_records,
              result: expected_results
            ).to_json
          )
        end
      end

      context 'when page is two' do
        let(:page) { 2 }
        let(:expected_records) { records.offset(per_page).limit(per_page) }

        it do
          is_expected.to eql(
            Panko::Response.new(
              page: page,
              limit: per_page,
              total: number_of_records,
              result: expected_results
            ).to_json
          )
        end
      end
    end

    context 'when options specified' do
      let(:per_page) { 4 }
      let(:number_of_records) { 2 }

      context 'when extra params are specified' do
        let(:options) { { extra_params: { sort_order: 'ASC' } } }

        context 'when there are no records' do
          let(:number_of_records) { 0 }
          let(:expected_records) { nil }

          it do
            is_expected.to eql(
              Panko::Response.new(
                {
                  page: page,
                  limit: per_page,
                  total: number_of_records,
                  result: expected_results
                }.merge(
                  options[:extra_params]
                )
              ).to_json
            )
          end
        end

        context 'when there are records' do
          let(:expected_records) { records }

          it do
            is_expected.to eql(
              Panko::Response.new(
                page: 1,
                limit: per_page,
                total: number_of_records,
                result: expected_results,
                sort_order: 'ASC'
              ).to_json
            )
          end
        end
      end

      context 'when context is specified' do
        let(:serializer) { TestContext }
        let(:expected_records) { records }
        let(:options) { { context: { value: 6 } } }

        it do
          is_expected.to eql(
            Panko::Response.new(
              page: 1,
              limit: per_page,
              total: number_of_records,
              result: expected_results
            ).to_json
          )
        end
      end
    end
  end
end
