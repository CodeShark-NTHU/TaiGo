# frozen_string_literal: true

module TaiGo
  module Database
    # Object-Relational Mapper for Routes
    class RouteOrm < Sequel::Model(:routes)
      one_to_many :owned_sub_routes,
                  class: :'TaiGo::Database::SubRouteOrm',
                  key: :route_id

      plugin :timestamps, update_on_create: true
    end
  end
end