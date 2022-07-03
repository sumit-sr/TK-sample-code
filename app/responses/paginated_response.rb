# frozen_string_literal: true

class PaginatedResponse
  include Pagy::Backend

  attr_reader :records, :serializer

  def initialize(records:, serializer:, page: 1, per_page: 20, options: nil)
    @serializer = serializer
    @options = options
    @pagy, @records = pagy(records, page: page, items: per_page)
  end

  def response
    if serialized_result.any?
      {
        page: @pagy.page,
        limit: @pagy.vars[:items],
        result: serialized_result,
        total: @pagy.count
      }
    else
      {}
    end
  end

  private

  def serialized_result
    records.map do |record|
      @options.blank? ? serializer.new(record).as_json : serializer.new(record, @options).as_json
    end
  end
end
