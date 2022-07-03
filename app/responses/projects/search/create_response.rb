# frozen_string_literal: true

module Projects
  module Search
    class CreateResponse < BaseResponse
      attr_reader :user

      Params = Struct.new(
        :limit,
        :page,
        :query,
        :sort_order,
        keyword_init: true
      )

      delegate_missing_to :@params

      def initialize(params:, user:)
        @params = Params.new(params.to_h)
        @user = user
      end

      private

      def success_hash
        PankoPaginatedResponse.new(
          page: page,
          per_page: limit,
          collection: user.projects.search(query),
          serializer: Projects::ShowSerializer
          # options: {
          #   extra_params: { sort_order: sort_order }
          # }
        ).response
      end
    end
  end
end
