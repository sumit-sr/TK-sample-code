# frozen_string_literal: true

module Extensions
  module ActiveRecord
    module FindByOrderedIds
      extend ActiveSupport::Concern
      module ClassMethods
        def find_ordered(ids)
          return where(id: ids) if ids.blank?

          order_clause = +'CASE id '
          ids.each_with_index do |id, index|
            order_clause << sanitize_sql_array(['WHEN ? THEN ? ', id, index])
          end
          order_clause << sanitize_sql_array(['ELSE ? END', ids.length])
          where(id: ids).order(Arel.sql(order_clause))
        end
      end
    end
  end
end
