# frozen_string_literal: true

class InvalidParams
  attr_reader :exception

  def initialize(exception)
    @exception = exception
  end

  def response
    {
      status: :bad_request,
      json: { errors: [exception] }
    }
  end
end
