# frozen_string_literal: true

namespace :service_fee do
  desc 'Load default service fee types'
  task load: :environment do
    ServiceFeeType.default_data
  end
end
