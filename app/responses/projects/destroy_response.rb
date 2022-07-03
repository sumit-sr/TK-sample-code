# frozen_string_literal: true

module Projects
  class DestroyResponse < BaseResponse
    attr_reader :project

    def initialize(project)
      @project = project
    end

    private

    def execute
      project.destroy
    end

    def success_hash
      { status: 'The Project has been deleted successfully.' }
    end
  end
end
