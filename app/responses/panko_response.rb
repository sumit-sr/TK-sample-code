# frozen_string_literal: true

class PankoResponse
  attr_reader :records, :serializer, :options, :extra_params

  def initialize(collection:, serializer:, options: {})
    @records = collection
    @serializer = serializer
    @options = options
    @extra_params = options.fetch(:extra_params, {})
  end

  def response
    return extra_params if records.none?

    Panko::Response.new(
      {
        result: Panko::ArraySerializer.new(
          records,
          each_serializer: serializer
        )
      }.merge(extra_params)
    )
  end
end
