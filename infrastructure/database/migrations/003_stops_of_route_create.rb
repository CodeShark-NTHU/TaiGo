
# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:stops_of_routes) do
      foreign_key :stop_uid, :stops
      foreign_key :route_uid, :routes
      Integer     :sub_route_uid
      Integer     :direction
      Integer     :stop_sequence
      Integer     :stop_boarding
      

      primary_key [:stop_uid, :route_uid, :sub_route_uid, :direction, :stop_sequence]
      index [:stop_uid, :route_uid, :sub_route_uid, :direction, :stop_sequence]
    end
  end
end