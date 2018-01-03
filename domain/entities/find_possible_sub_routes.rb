# frozen_string_literal: true
require_relative '../database_repositories/stop_of_routes.rb'
require_relative 'nearest_stops_to_location.rb'
require_relative '../tool/cal_distance.rb'

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

      def sort
        @sort_result = {}
        @final_hash = {}
        @tmpCal = Tool::CalDistance.new(@start_lat, @start_lng)
        @result.each do |key, value|
          @sort_result[[key,value]] = @tmpCal.cal_distance(value.coordinates.latitude,value.coordinates.longitude)
        end
        @sort_result.sort_by { |_key, value| value }.to_h
        final_third = @sort_result.keys.first 3
        final_third.each do |anw|
          @final_hash[anw[0]] = anw[1] 
        end 
        @final_hash
      end

      def build_entity
        find_the_closest_stop
        # sort
        possible_sub_route_set = []
        @result.each do |key, value|
          possible_sub_route_set << Entity::PossibleSubRoute.new(
            start_stop: value,
            stops_of_sub_route: key
          )
        end
=begin
        @final_hash.each do |key, value|
          possible_sub_route_set << Entity::PossibleSubRoute.new(
            start_stop: value,
            stops_of_sub_route: key
          )
        end
=end
        # rebuild entity
        Entity::PossibleSubRoutes.new(
          destination_stop: @dest_stop,
          sub_route_set: possible_sub_route_set
        )
      end
    end
  end
end
