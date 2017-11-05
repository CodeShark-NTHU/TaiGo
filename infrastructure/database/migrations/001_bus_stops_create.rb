# frozen_string_literal: false

require 'sequel'

# so happy today
Sequel.migration do
  change do
    create_table(:bus_stops) do
      primary_key :uid
      String      :name_zh
      String      :name_en
      Float       :lang
      Float       :long
      Integer     :auth_id
      String      :address

      DateTime :created_at
      DateTime :updated_at
    end
  end
end