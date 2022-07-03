# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invite do
  context 'Associations' do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:user) }
    # it { is_expected.to have_many(:comments) }
    it do
      is_expected.to belong_to(:tasker).class_name('User')
                                       .with_foreign_key('tasker_id')
    end
  end
end
