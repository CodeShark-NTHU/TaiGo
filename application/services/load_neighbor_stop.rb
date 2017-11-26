# frozen_string_literal: true

require 'dry/transaction'
require_relative '../../domain/tool/cal_dist.rb'

module TaiGo
  # Transaction to load routes from Motc and save to database
  class LoadNeighborStop
    include Dry::Transaction

    step :get_stops_in_db
    step :get_distance_list
    step :sort_by_dist
    step :give_neighbor_stops

    def get_stops_in_db(input)
      location_set = []
      stops = Repository::For[Entity::BusStop].all
      location_set << input[:user_lat]
      location_set << input[:user_lng]
      location_set << stops
      if stops.empty?
        Left(Result.new(:not_found, 'stopofroutes not found'))
      else
        Right(location_set: location_set)
      end
    end

    def get_distance_list(input)
      distance_set = {}
      user_lat = input[:location_set][0].to_f
      user_lng = input[:location_set][1].to_f
      input[:location_set][2].map do |stop|
        result = Distance.cal_dist(user_lat, user_lng, stop.coordinates.latitude , stop.coordinates.longitude)
        distance_set[stop] = result
      end
      Right(distance_set: distance_set)
    end

    def sort_by_dist(input)
      rank = input[:distance_set].sort_by { |_key, value| value }.to_h
      Right(rank: rank.keys)
    end

    def give_neighbor_stops(input)
      final = input[:rank].first 5
      Right(final)
    end
  end
end
