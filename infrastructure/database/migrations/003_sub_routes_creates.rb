# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:sub_routes) do
      String      :id, primary_key: true
      foreign_key :route_id, :routes
      String      :name_zh
      String      :name_en
      String      :headsign
      Integer     :direction

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
