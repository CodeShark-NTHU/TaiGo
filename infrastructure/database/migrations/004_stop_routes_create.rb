
# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:stop_routes) do
      foreign_key :stops_of_routes_id, :stops_of_routes
      foreign_key :stop_id, :stops, type: String
  

      primary_key [:stop_id , :stops_of_routes_id]
      index [:stop_id, :stops_of_routes_id]
    end
  end
end