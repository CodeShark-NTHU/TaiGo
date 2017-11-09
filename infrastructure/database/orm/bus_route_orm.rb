# frozen_string_literal: true

module TaiGo
    module Database
      # Object Relational Mapper for BusRoute Entities
      class BusRouteOrm < Sequel::Model(:routes)
        one_to_many   :stops_of_routes,
                      class:  :'TaiGo::Database::StopsOfRoutesOrm',
                      key:    :route_id 
        
=begin
#version 2
        many_to_many :stops_of_routes,
                    join_table: :route_stops,
                    left_key: :route_id, right_key: :stops_of_routes_id
=end
=begin  
        many_to_many :stops,
                     class: :'TaiGo::Database::BusStopOrm',
                     join_table: :stops_of_routes,
                     left_key: :route_uid, right_key: :stop_uid
=end
  
        plugin :timestamps, update_on_create: true
      end
    end
  end
  