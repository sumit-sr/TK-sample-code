# frozen_string_literal: true

RESPONDS_WITH_USER = 'responds with user'
EMAIL_NOT_FOUND = 'Email address not found. Please check and try again.'
NO_RESET_REQUEST = "We didn't find reset password request for the user."
NO_CNF_REQUEST = "We didn't find any email confirmation request for the user."

RSpec.shared_examples RESPONDS_WITH_USER do |status_code|
  it_behaves_like "#{status_code} response status"

  it 'returns a proper JSON response' do
    hash = JSON.parse(response.body).deep_symbolize_keys!
    user = User.last

    expect(hash).to eql(
      Users::ShowSerializer.new.serialize(user).deep_symbolize_keys!
    )
  end
end

RSpec.shared_examples 'handles valid token response' do
  it 'returns a proper token as part of the JSON response' do
    hash = JSON.parse(response.body).deep_symbolize_keys!
    decoded_token = JsonWebToken.decode(hash[:token])

    expect(decoded_token[:user_id]).to eql(user.id)
    expect(decoded_token[:exp]).to be_within(3).of((Time.now + 24.hours).to_i)
  end
end

RSpec.shared_examples 'user not authorize' do
  context 'when user is not authorized' do
    it_behaves_like(
      RESPONSE_STATUS_400,
      ['You are not authorize to perform this action.']
    )
  end
end
