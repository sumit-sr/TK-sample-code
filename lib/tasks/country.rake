# frozen_string_literal: true

require 'csv'

namespace :country do
  desc 'Load countries and zipcodes'
  task load: :environment do
    CountryDataLoader.new.set_state_zip_codes
  end

  desc 'Load countries and zipcodes'
  task load_indian_zip_codes: :environment do
    IndianZipCodes.new.load_data
  end

  desc 'Update countries with alpha2 code'
  task add_alpha_2_codes_for_country: :environment do
    IndianZipCodes.new.update_countries
  end
end
