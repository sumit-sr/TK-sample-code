# frozen_string_literal: true

module Tasks
  class BasicSerializer < Panko::Serializer
    attributes(
      :id,
      :title
    )
  end
end
