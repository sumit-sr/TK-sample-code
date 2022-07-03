# frozen_string_literal: true

class BaseResponse
  def response
    execute

    { json: to_h, status: status }
  end

  def status
    valid? ? :ok : :bad_request
  end

  def to_h
    valid? ? success_hash : errors_hash
  end

  def errors
    @errors ||= []
  end

  def valid?
    errors.empty?
  end

  def errors_hash
    { errors: errors }
  end

  def success_hash
    # override this method in the inherited class with the
    # desired response data hash

    {}
  end

  private

  def execute
    # If there is code that needs to be run before the response is ready,
    # create an execute method in the inherited class
  end
end
