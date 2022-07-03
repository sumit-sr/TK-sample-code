# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :current_user

  DEFAULT_PER_PAGE = AppConfig['paginate_per_page']['default']
  SIGN_IN = 'You need to sign in or sign up before continuing.'

  private

  def process_request
    yield
  rescue InvalidParameterError => e
    render InvalidParams.new(e).response
  rescue StandardError => e
    render ServerError.new(e).response
  end

  def not_found
    render json: { errors: ['not_found'] }, status: :bad_request
  end

  def authenticate_request
    return render json: { errors: [SIGN_IN] }, status: :unauthorized if access_token.blank?

    fetch_user
  end

  def authenticate_user
    return if access_token.blank?

    fetch_user
  end

  def fetch_user
    return fetch_user_from_local if Rails.env.eql?('test')

    user_detail

    return render json: @response, status: @status unless @status.eql?(200)

    @current_user = User.where(master_user_id: @response['id']).first_or_create
    if @current_user.present?
      @current_user.master_user = @response.deep_symbolize_keys
      authenticate_user_if_account_not_deactivated
    else
      @master_user_id = @response['id']
    end
  end

  def user_detail
    @response, @status = Users::ShowService.new(
      access_token: access_token
    ).call
  end

  def access_token
    @access_token ||= request.headers['Authorization']
  end

  def parse_exception(exception)
    exception&.to_s&.humanize&.gsub('Parameter ', '')
  end

  def authenticate_user_if_account_not_deactivated
    return unless current_user.deactivated?

    errors = ['Your account is deactivated, please contact support.']
    render json: { errors: errors }, status: :unauthorized
  end

  # For RSpec testing only
  def fetch_user_from_local
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      @decoded = JsonWebToken.decode(header)
      find_or_create_kaargar_user
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [e.message] }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: [e.message] }, status: :unauthorized
    end
  end

  # For RSpec testing only
  def find_or_create_kaargar_user
    @current_user = User.find_by(id: @decoded[:user_id])
    # @current_user = KaargarUser.where(master_user_id: @decoded[:user_id]).first_or_create
  end
end
