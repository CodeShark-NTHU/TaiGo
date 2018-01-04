# frozen_string_literal: true

module TaiGo
  module Database
    # Object-Relational Mapper for Stops
    class StopOrm < Sequel::Model(:stops)
      one_to_many :stop_of_routes,
                  class: :'TaiGo::Database::StopOfRouteOrm',
                  key: :stop_id

      plugin :timestamps, update_on_create: true
    end
  end
end
