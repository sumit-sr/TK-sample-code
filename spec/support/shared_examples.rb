# frozen_string_literal: true

RETURNS_JSON_ERROR_RESPONSE = 'returns a JSON error response'
RETURNS_JSON_RESPONSE = 'returns a proper JSON response'
INVALID_PARAMS = 'handles an invalid param'
RESPONSE_STATUS_400 = '400 response status'
RESPONSE_STATUS_201 = '201 response status'
RESPONSE_STATUS_200 = '200 response status'
STATUS_401 = '401 status'
STATUS_400 = '400 status'
DATE_FORMAT = '%FT%T.%LZ'
PARSE_TAG = /\[\[\[(.*?)\]\]\]/

RSpec.shared_examples 'handles missing credentials' do
  context 'when no user credentials are provided' do
    it_behaves_like STATUS_401

    it RETURNS_JSON_ERROR_RESPONSE do
      hash = JSON.parse(response.body).deep_symbolize_keys!

      expect(hash).to eql(errors: ['You need to sign in or sign up before continuing.'])
    end
  end
end

RSpec.shared_examples INVALID_PARAMS do |expected_errors|
  it_behaves_like STATUS_400

  it RETURNS_JSON_ERROR_RESPONSE do
    hash = JSON.parse(response.body).deep_symbolize_keys!

    expect(hash).to eql(errors: expected_errors)
  end
end

RSpec.shared_examples 'handles a bad request' do |expected_errors|
  it_behaves_like STATUS_400

  it 'returns a JSON error response' do
    hash = JSON.parse(response.body).deep_symbolize_keys!

    expect(hash).to eql(errors: expected_errors)
  end
end

RSpec.shared_examples '404 response status' do |expected_errors|
  it 'returns a status of 404' do
    expect(response).to have_http_status(404)
  end

  it RETURNS_JSON_ERROR_RESPONSE do
    hash = JSON.parse(response.body).deep_symbolize_keys!

    expect(hash).to eql(errors: expected_errors)
  end
end

RSpec.shared_examples '401 response status' do |expected_errors|
  it_behaves_like STATUS_401

  it RETURNS_JSON_ERROR_RESPONSE do
    hash = JSON.parse(response.body).deep_symbolize_keys!

    expect(hash).to eql(errors: expected_errors)
  end
end

RSpec.shared_examples '400 response status' do |expected_errors|
  it_behaves_like STATUS_400

  it RETURNS_JSON_ERROR_RESPONSE do
    hash = JSON.parse(response.body).deep_symbolize_keys!

    expect(hash).to eql(errors: expected_errors)
  end
end

RSpec.shared_examples 'bad request' do
  it 'returns a status of 400' do
    expect(response).to have_http_status(400)
  end
end

RSpec.shared_examples RESPONSE_STATUS_200 do
  it 'returns a status of 200' do
    expect(response).to have_http_status(200)
  end
end

RSpec.shared_examples RESPONSE_STATUS_201 do
  it 'returns a status of 201' do
    expect(response).to have_http_status(201)
  end
end

RSpec.shared_examples STATUS_400 do
  it 'returns a status of 400' do
    expect(response).to have_http_status(400)
  end
end

RSpec.shared_examples STATUS_401 do
  it 'returns a status of 401' do
    expect(response).to have_http_status(401)
  end
end

RSpec.shared_examples 'handles invalid page params' do
  context 'when there are invalid params' do
    let(:params) { { page: 'one' } }

    it_behaves_like(
      INVALID_PARAMS, ["'one' is not a valid Integer"]
    )
  end
end

RSpec.shared_examples '200 response status with message' do |expected_msg|
  it_behaves_like RESPONSE_STATUS_200

  it RETURNS_JSON_RESPONSE do
    hash = JSON.parse(response.body).deep_symbolize_keys!

    expect(hash).to eql(status: expected_msg)
  end
end

RSpec.shared_examples '201 response status with message' do |expected_msg|
  it_behaves_like RESPONSE_STATUS_201

  it RETURNS_JSON_RESPONSE do
    hash = JSON.parse(response.body).deep_symbolize_keys!

    expect(hash).to eql(status: expected_msg)
  end
end

RSpec.shared_examples 'assert email' do |num|
  it 'sends a notification' do
    assert_emails num
  end
end
