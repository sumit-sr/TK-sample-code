# frozen_string_literal: true

module Projects
  class CreateResponse < BaseResponse
    attr_reader :params, :user, :status

    Params = Struct.new(
      :title,
      :description,
      :start_date,
      :end_date,
      :estimated_budget,
      :im_not_sure,
      keyword_init: true
    )

    delegate_missing_to :@params

    def initialize(params:, user:)
      @params = Params.new(params.to_h)
      @user = user
      @status = :bad_request
    end

    private

    def execute
      process_to_add_account if valid?
    end

    def process_to_add_account
      if project.persisted?
        @status = :created
      else
        @errors = project.errors
      end
    end

    def project
      @project ||= user.projects.create!(
        title: title,
        description: description,
        start_date: start_date,
        end_date: end_date,
        estimated_budget: estimated_budget,
        im_not_sure: im_not_sure
      )
    end

    def success_hash
      { status: 'project added successfully.' }
    end
  end
end
