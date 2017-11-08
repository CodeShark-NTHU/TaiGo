# frozen_string_literal: true

module TaiGo
    module Database
      # Object Relational Mapper for BusRoute Entities
      class BusRouteOrm < Sequel::Model(:routes)
    
        many_to_many :stops,
                     class: :'TaiGo::Database::BusStopOrm',
                     join_table: :stops_of_routes,
                     left_key: :route_uid, right_key: :stop_uid
  
        plugin :timestamps, update_on_create: true
      end
    end
  end
  