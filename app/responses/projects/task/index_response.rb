# frozen_string_literal: true

module Projects
  module Task
    class IndexResponse < BaseResponse
      attr_reader :params, :project, :access_token

      Params = Struct.new(
        :page,
        :limit,
        keyword_init: true
      )

      delegate_missing_to :@params

      def initialize(params:, project:, access_token:)
        @params = Params.new(params.to_h)
        @project = project
        @access_token = access_token
      end

      private

      def success_hash
        PankoPaginatedResponse.new(
          page: page,
          per_page: limit,
          collection: project.tasks.order('created_at DESC'),
          serializer: Tasks::BasicInfoSerializer,
          options: {
            context: { access_token: access_token }
          }
        ).response
      end
    end
  end
end
