# frozen_string_literal: true

module TaiGo
  module Repository
    For = {
      Entity::BusStop         => Stops,
      Entity::BusRoute        => Routes,
      Entity::BusSubRoute     => Sub_outes,
      Entity::StopOfRoute     => Stop_of_routes
    }.freeze
  end
end