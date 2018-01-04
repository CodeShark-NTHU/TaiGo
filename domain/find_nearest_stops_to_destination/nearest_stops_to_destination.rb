# frozen_string_literal: true

require_relative '../domain/tool/cal_distance.rb'

module TaiGo
  # for cal dist
  module Destination
    class FindNearestStops
    
      NEAREST_STOP_NUM = 5 # for return to user.

      def initialize(allofstops)
        @allofstops = allofstops
      end

      def initialize_dest(dest_lat,dest_lng)
        @tmpCal = Tool::CalDistance.new(dest_lat, dest_lng)
      end

      def sort_by_distance(set)
       set.sort_by { |_key, value| value }.to_h
      end

      def find_nearest_stops()
        distance_set = {}
        @allofstops.map do |stop|
          result = @tmpCal.cal_distance(stop.coordinates.latitude , stop.coordinates.longitude)
          distance_set[stop] = result
        end
        distance_set = sort_by_distance(distance_set)
        distance_set.keys.first NEAREST_STOP_NUM
      end
    end
  end
end
