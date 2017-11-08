
# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:route_stops) do
      foreign_key :stops_of_routes_id, :stops_of_routes
      foreign_key :route_id, :routes, type: String
      

      primary_key [:route_id , :stops_of_routes_id]
      index [:route_id, :stops_of_routes_id]
    end
  end
end