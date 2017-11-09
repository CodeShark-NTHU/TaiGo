# frozen_string_literal: true

module TaiGo
  module Database
    # Object-Relational Mapper for Sub_routes
    class SubRouteOrm < Sequel::Model(:sub_routes)
      one_to_many :owned_stop_of_routes,
                  class: :'TaiGo::Database::StopOfRoute',
                  key: :sub_route_id

      plugin :timestamps, update_on_create: true
    end
  end
end