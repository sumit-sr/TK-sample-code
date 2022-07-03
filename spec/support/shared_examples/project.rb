# frozen_string_literal: true

RSpec.shared_examples 'handles invalid project ID' do
  context 'when there is invalid ID' do
    let(:path) { project_path('1') }

    it_behaves_like '400 response status', ['Project not found, or invalid id']
  end
end
