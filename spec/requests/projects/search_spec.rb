# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Projects::SearchController, type: :request do
  let(:headers) { {} }
  let(:path) { '/projects/search' }
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let(:query) { 'invalid' }
  let(:params) { { query: query } }

  before(:example) do
    post(path, params: params, headers: headers).to_json
  end

  describe '#create' do
    it_behaves_like('handles missing credentials')

    context 'when user credentials are provided' do
      include_context 'when user credentials are provided'

      it_behaves_like 'handles invalid page params'

      context 'when there are no search/filter params' do
        let(:params) { { query: query } }

        it_behaves_like '200 response status'

        it 'returns a proper JSON response' do
          hash = JSON.parse(response.body)

          expect(hash).to eql(
            'limit' => 10,
            'page' => 1,
            'result' => [],
            'total' => 0
          )
        end
      end

      context 'when there are search/filter params' do
        let(:params) { { query: Project.first.title.split(' ').last } }

        it_behaves_like '200 response status'

        it 'returns a proper JSON response' do
          hash = JSON.parse(response.body).deep_symbolize_keys!

          expect(hash).to eql(
            limit: 10,
            page: 1,
            result: [
              JSON.parse(
                Projects::ShowSerializer.new.serialize_to_json(project)
              ).deep_symbolize_keys!
            ],
            total: 1
          )
        end
      end
    end
  end
end
