# frozen_string_literal: true

class PankoPaginatedResponse
  include Pagy::Backend

  attr_reader :records, :serializer, :options, :context, :extra_params

  def initialize(collection:, serializer:, page: 1, per_page: 20, options: {})
    @serializer = serializer
    if collection.is_a?(Array)
      @pagy, @records = pagy_array(collection, page: page, items: per_page)
    else
      @pagy, @records = pagy(collection, page: page, items: per_page)
    end
    @options = options
    @context = options[:context]
    @extra_params = options.fetch(:extra_params, {})
  end

  def response
    Panko::Response.new(
      pagination_info.merge(
        result: Panko::ArraySerializer.new(
          records,
          each_serializer: serializer,
          context: context
        )
      ).merge(extra_params)
    )
  end

  private

  def pagination_info
    {
      page: @pagy.page,
      limit: @pagy.vars[:items],
      total: @pagy.count
    }
  end
end
