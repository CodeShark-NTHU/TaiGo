# frozen_string_literal: true

module TaiGo
  module Database
    # Object-Relational Mapper for Stop of Routes
    class StopOfRouteOrm < Sequel::Model(:stop_of_routes)
      # many_to_one :sub_route,
      #             class: :'TaiGo::Database::SubRouteOrm'
      many_to_one :stop,
                  class: :'TaiGo::Database::StopOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
