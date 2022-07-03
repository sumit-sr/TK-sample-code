# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  let(:params) { {} }
  let(:headers) { {} }
  let!(:poster) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:user) { poster }
  let!(:project) { create(:project, user: poster) }
  let(:path) { project_path(project.id) }
  let(:title) { 'title' }
  let(:description) { Faker::Lorem.sentence }

  let(:params_data) do
    {
      title: title,
      description: description
    }
  end

  before(:example) do
    patch(path, params: params, headers: headers)
  end

  describe '#update' do
    it_behaves_like 'handles missing credentials'

    context 'when user credentials are provided' do
      include_context 'when user credentials are provided'

      it_behaves_like 'handles invalid project ID'

      context 'when there is valid ID' do
        let(:user) { other_user }
        include_context 'user not authorize'

        context 'when there is authorize user' do
          let(:user) { poster }
          let(:params) { params_data }

          it_behaves_like '200 response status'

          it 'returns a proper JSON response' do
            hash = JSON.parse(response.body).deep_symbolize_keys!

            expect(hash).to eql(
              Projects::ShowSerializer.new.serialize(project.reload)
                .deep_symbolize_keys!
            )
          end
        end
      end
    end
  end
end
