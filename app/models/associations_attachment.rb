# frozen_string_literal: true

class AssociationsAttachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  belongs_to :attachment
end
