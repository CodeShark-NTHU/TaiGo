# frozen_string_literal: true

module TaiGo
  module Database
    ORM = {
      TaiGo::Entity::BusRoute => RouteOrm,
      TaiGo::Entity::BusSubRoute => SubRouteOrm,
      TaiGo::Entity::BusStop => StopOrm,
      TaiGo::Entity::StopOfRoute => StopOfRouteOrm
    }.freeze
  end
end
