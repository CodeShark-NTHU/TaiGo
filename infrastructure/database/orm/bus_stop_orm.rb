# frozen_string_literal: false

module TaiGo
    module Database
        class BusStopOrm < Sequel::Model(:bus_stop)

            many_to_many :routes,
            join_table: :stops_of_routes,
            left_key: :stop_uid, right_key: :route_uid

        end
    end
end