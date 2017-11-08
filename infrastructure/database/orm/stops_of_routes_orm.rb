# frozen_string_literal: true

module TaiGo
    module Database
      # Object Relational Mapper for BusStop Entities
      class StopsOfRoutesOrm < Sequel::Model(:stops_of_routes)
        many_to_many :stops,
                      class: :'TaiGo::Database::BusStopOrm',
                      join_table: :stop_routes,
                      left_key: :stops_of_routes_id, right_key: :stop_id
        
        many_to_many :routes,
                      class: :'TaiGo::Database::BusRouteOrm',
                      join_table: :route_stops,
                      left_key: :stops_of_routes_id, right_key: :route_id
  
        plugin :timestamps, update_on_create: true
      end
    end
  end
  