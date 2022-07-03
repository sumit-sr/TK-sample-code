# frozen_string_literal: true

class UserService < HttpService
  attr_reader :user_id, :file

  def initialize(user_id: nil, access_token: nil, file: nil)
    @user_id = user_id
    @access_token = access_token
    @file = file
  end

  def service_server_url
    ENV['USER_SERVER_URL'] || 'http://localhost:4000'
  end
end
