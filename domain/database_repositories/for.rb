# frozen_string_literal: true

module TaiGo
    module Repository
      For = {
        Entity::BusStop       => BusStops,
        Entity::BusRoute => BusRoutes
      }.freeze
    end
  end