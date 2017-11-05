
# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:stops_of_routes) do
      foreign_key :stop_id, :stops
      foreign_key :route_id, :routes
      String      :sub_route_uid
      Integer     :direction
      Integer     :stop_sequence
      Integer     :stop_boarding
      

      primary_key [:stop_id, :route_id, :sub_route_uid, :direction, :stop_sequence]
      index [:stop_id, :route_id, :sub_route_uid, :direction, :stop_sequence]
    end
  end
end