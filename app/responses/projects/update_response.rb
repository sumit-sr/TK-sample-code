# frozen_string_literal: true

module Projects
  class UpdateResponse < BaseResponse
    attr_reader :project, :params, :access_token

    def initialize(project:, params:, access_token:)
      @params = params
      @project = project
      @access_token = access_token
    end

    private

    def execute
      process_to_update_project
    end

    def process_to_update_project
      if project.update(params)
        @status = :ok
      else
        @errors = project.errors
      end
    end

    def success_hash
      Projects::ShowSerializer.new(
        context: { access_token: access_token }
      ).serialize(project)
    end
  end
end
