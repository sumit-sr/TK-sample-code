# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  let(:params) { {} }
  let(:headers) { {} }
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let(:path) { project_path(id) }
  let(:id) { project.id }

  before(:example) do
    delete(path, params: params, headers: headers)
  end

  describe '#destroy' do
    it_behaves_like 'handles missing credentials'

    context 'when user credentials are provided' do
      include_context 'when user credentials are provided'

      it_behaves_like 'handles invalid project ID'

      context 'when there is valid ID' do
        let(:path) { project_path(project.id) }

        it_behaves_like(
          '200 response status with message',
          'The Project has been deleted successfully.'
        )
      end
    end
  end
end
