# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_request
  before_action :set_project, only: %i[show destroy update]
  before_action :authorise_user, only: %i[update destroy]

  # def index
  #   process_request do
  #     validate_pagination_params

  #     render Projects::IndexResponse.new(
  #       params: paginated_params,
  #       user: current_user,
  #       access_token: @access_token
  #     ).response
  #   end
  # end

  def create
    process_request do
      validate_params

      render Projects::CreateResponse.new(
        params: project_params,
        user: current_user
      ).response
    end
  end

  def show
    process_request do
      render json: Projects::ShowSerializer.new(
        context: { access_token: @access_token }
      ).serialize(project)
    end
  end

  def update
    process_request do
      validate_params

      render Projects::UpdateResponse.new(
        project: project,
        params: project_params,
        access_token: @access_token
      ).response
    end
  end

  def destroy
    process_request do
      render Projects::DestroyResponse.new(project).response
    end
  end

  private

  def authorise_user
    return if project.user == current_user

    render json: { errors: ['You are not authorize to perform this action.'] }, status: :bad_request
  end

  def project
    @project ||= Project.find_by(id: params[:id])
  end

  def project_params
    params.permit(:title, :description, :start_date, :end_date, :estimated_budget, :im_not_sure)
  end

  def set_project
    return if project.present?

    project_not_found = 'Project not found, or invalid id'

    render json: { errors: [project_not_found] }, status: :bad_request
  end

  def paginated_params
    params.permit(:page, :limit)
  end

  def validate_params
    %i[title description].each do |field_name|
      param! field_name, String, blank: false, required: !request.patch?
    end
    %i[start_date end_date].each do |field_name|
      param! field_name, Date, blank: false, required: false
    end
    param! :estimated_budget, Float, blank: false, required: false
    param! :im_not_sure, :boolean, blank: false, required: true, default: false
  end

  def validate_pagination_params
    param! :page, Integer, min: 1, default: 1
    param! :limit, Integer,
           required: false,
           default: AppConfig['paginate_per_page']['default']
  end
end
