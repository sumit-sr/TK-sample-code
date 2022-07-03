# frozen_string_literal: true

RSpec.shared_context 'when user credentials are provided' do
  let(:user) { create(:user, :with_addresses) }
  let(:kaargar_user) { KaargarUser.find_by(master_user_id: user.id) }
  let(:expire_time) { Time.now + 1.year }
  let(:token) { JsonWebToken.encode(user_id: user.id, exp: expire_time) }
  let(:params) { {} }
  let(:headers) { { 'Authorization' => token } }
end
