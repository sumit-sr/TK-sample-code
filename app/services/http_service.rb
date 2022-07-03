# frozen_string_literal: true

class HttpService
  require 'faraday'
  attr_reader :access_token, :url

  private

  def connection
    Faraday.new(url: service_server_url)
  end

  def get
    response = JSON.parse response_for_get.body

    [response, response_for_get.status]
  end

  def post
    response = JSON.parse post_response.body

    [response, post_response.status]
  end

  def response_for_get
    @response_for_get ||= connection.get url, params do |request|
      request.headers['Authorization'] = access_token
    end
  end

  def post_response
    @post_response ||= connection.post url, payload do |request|
      request.headers['Authorization'] = access_token
    end
  end

  def params
    @params ||= {}
  end

  def payload
    @payload ||= {}
  end

  def service_server_url; end
end
