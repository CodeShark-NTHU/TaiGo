# frozen_string_literal: true
require_relative '../database_repositories/stop_of_routes.rb'
require_relative 'nearest_stops_to_location.rb'

module TaiGo
  module Entity
    class FindPossibleSubSubroutes

      def initialize(dest_stop, start_lat, start_lng)
        @dest_stop = dest_stop
        @start_lat = start_lat
        @start_lng = start_lng
      end

       def find_sub_route_set
        @sub_route_set = Repository::For[Entity::StopOfRoute].find_sub_route_set(@dest_stop.id)
      end

      def find_the_closest_stop
        # entity of stop_of_route
        find_sub_route_set
        stop_set = []
        @result = {}
        @sub_route_set.map do |sub_route|
          sub_route.map do |stop_of_route|
            stop_set << stop_of_route.stop
          end
          stops = Entity::FindNearestStops.new(stop_set)
          stops.initialize_location(@start_lat, @start_lng)
          # entity of stop
          @result[sub_route] = stops.find_nearest_stop
        end
      end

      def build_entity
        find_the_closest_stop
        possible_sub_route_set = []
        @result.each do |key, value|
          possible_sub_route_set << Entity::PossibleSubRoute.new(
            start_stop: value,
            stops_of_sub_route: key
          )
        end
        # rebuild entity
        Entity::PossibleSubRoutes.new(
          destination_stop: @dest_stop,
          sub_route_set: possible_sub_route_set
        )
      end
    end
  end
end
