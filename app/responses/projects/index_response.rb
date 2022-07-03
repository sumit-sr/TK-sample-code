# frozen_string_literal: true

module Projects
  class IndexResponse < BaseResponse
    attr_reader :params, :user, :access_token

    Params = Struct.new(
      :page,
      :limit,
      keyword_init: true
    )

    delegate_missing_to :@params

    def initialize(params:, user:, access_token:)
      @params = Params.new(params.to_h)
      @user = user
      @access_token = access_token
    end

    private

    def success_hash
      PankoPaginatedResponse.new(
        page: page,
        per_page: limit,
        collection: user.projects.order('created_at DESC'),
        serializer: Projects::ShowSerializer,
        options: {
          context: { access_token: access_token }
        }
      ).response
    end
  end
end
