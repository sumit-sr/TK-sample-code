# frozen_string_literal: true

module Users
  class ShowService < UserService
    def call
      @url = 'users'
      get
    end

    def image
      @url = 'users/image'
      @payload = { file: @file }
      post
    end
  end
end
