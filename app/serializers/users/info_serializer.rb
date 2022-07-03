# frozen_string_literal: true

module Users
  class InfoSerializer < Panko::Serializer
    attributes(
      :id,
      :first_name,
      :last_name,
      :profile_pic,
      :profile_pic_alt,
      :rating_as_a_poster
    )
  end
end
