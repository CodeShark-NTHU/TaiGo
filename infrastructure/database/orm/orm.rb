# frozen_string_literal: true

module TaiGo
   module Database
     ORM = {
       TaiGo::Entity::BusRoute => BusRouteOrm,
       TaiGo::Entity::BusStop => BusStopOrm
     }.freeze
   end
 end