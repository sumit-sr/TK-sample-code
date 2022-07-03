# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  let(:params) { {} }
  let(:headers) { {} }
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let(:path) { project_path(project.id) }

  before(:example) do
    get(path, params: params, headers: headers)
  end

  describe '#show' do
    it_behaves_like 'handles missing credentials'

    context 'when user credentials are provided' do
      include_context 'when user credentials are provided'

      it_behaves_like 'handles invalid project ID'

      context 'when there is valid ID' do
        let(:path) { project_path(project.id) }

        it_behaves_like '200 response status'

        it 'returns a proper JSON response' do
          hash = JSON.parse(response.body).deep_symbolize_keys!

          expect(hash).to eql(
            JSON.parse(
              Projects::ShowSerializer.new.serialize_to_json(project)
            ).deep_symbolize_keys!
          )
        end
      end
    end
  end
end
