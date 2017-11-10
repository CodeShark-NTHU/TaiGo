# frozen_string_literal: true

module TaiGo
  module Repository
    For = {
      Entity::BusStop         => Stops,
      Entity::BusRoute        => Routes,
      Entity::BusSubRoute     => SubRoutes,
      Entity::StopOfRoute     => StopOfRoutes
    }.freeze
  end
end
