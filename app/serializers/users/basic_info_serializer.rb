# frozen_string_literal: true

module Users
  class BasicInfoSerializer < Panko::Serializer
    attributes(
      :id,
      :first_name,
      :last_name,
      :profile_pic,
      :profile_pic_alt,
      :rating_as_a_poster
    )

    def master_user_detail
      @response, @status = Users::ShowService.new(
        user_id: object.master_user_id,
        access_token: access_token
      ).call
      object.master_user = @response.deep_symbolize_keys
    end

    # TODO
    def first_name
      master_user_detail
      object.master_user[:first_name]
    end

    def last_name
      object.master_user[:last_name]
    end

    def profile_pic
      object.master_user[:profile_pic]
    end

    def profile_pic_alt
      object.master_user[:profile_pic_alt]
    end

    def access_token
      return unless defined?(context)

      return if context.nil?

      context[:access_token]
    end
  end
end
