# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:bus_routes) do
      primary_key :uid
      String      :name_zh
      String      :name_en
      String      :depart_name
      Float       :destination_name
      Integer     :auth_id

      DateTime :created_at
      DateTime :updated_at
    end
  end
end