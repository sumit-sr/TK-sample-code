# frozen_string_literal: true

module Projects
  class TasksController < ApplicationController
    before_action :authenticate_user

    def index
      process_request do
        validate_pagination_params
        render Projects::Task::IndexResponse.new(
          params: paginated_params,
          project: project,
          access_token: @access_token
        ).response
      end
    end

    private

    def authorise_user
      return if project.user == current_user

      render json: { errors: ['You are not authorised to perform this action'] }, status: :bad_request
    end

    def project
      @project ||= Project.find_by(id: params[:id])
    end

    def paginated_params
      params.permit(:page, :limit)
    end

    def validate_pagination_params
      param! :page, Integer, min: 1, default: 1
      param! :limit, Integer, required: false,
                              default: DEFAULT_PER_PAGE
    end
  end
end
