
# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:stops_of_routes) do
      #foreign_key :stop_uid, :stops, type: String
      #foreign_key :route_uid, :routes, type: String
      primary_key :id
#      String      :stop_uid
#      String      :route_uid
      String      :sub_route_uid
      Integer     :direction
      Integer     :stop_sequence
      Integer     :stop_boarding
      

      #primary_key [:stop_uid, :route_uid]
      #index [:stop_uid, :route_uid]
    end
  end
end