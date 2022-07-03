# frozen_string_literal: true

module Projects
  class SearchController < ApplicationController
    before_action :authenticate_request

    def create
      process_request do
        validate_params
        render Projects::Search::CreateResponse.new(
          params: filter_params,
          user: current_user
        ).response
      end
    end

    private

    def validate_params
      pagination_filters
      param! :query, String, default: nil
    end

    def filter_params
      params.permit(
        :query,
        :sort_order,
        :page,
        :limit
      )
    end

    def pagination_filters
      param! :page, Integer, min: 1, default: 1
      param! :limit, Integer, required: false,
                              default: AppConfig['paginate_per_page']['default']
      # param! :sort_order, String, in: %w[ASC DESC],
      # transform: :upcase, default: 'ASC'
    end
  end
end
