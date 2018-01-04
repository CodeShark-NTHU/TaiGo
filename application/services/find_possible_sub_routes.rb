# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to load stops from Motc and save to database
  class FindPossibleSubRoutes
    # old version for search.rb
    include Dry::Transaction

    step :get_all_stops_from_db
    step :get_stops_near_both_start_dest
    step :get_match_sub_route

    def get_all_stops_from_db(input)
      all_of_stops = Repository::For[Entity::BusStop].all
      if all_of_stops.empty?
        Left(Result.new(:not_found, "there are no stops in db."))
      else
        result = [input[:s_lat], input[:s_lng], input[:d_lat], input[:d_lng]]
        result << all_of_stops
        Right(result: result)
      end
    end

    def get_stops_near_both_start_dest(input)
      start_lat = input[:result][0]
      start_lng = input[:result][1]
      all_of_stops = input[:result][4]
      start = Entity::FindNearestStops.new(all_of_stops)
      start.initialize_location(start_lat, start_lng)
      s_piars_of_stopdis = start.find_top_nearest_stops
      result_start = []
      s_piars_of_stopdis.map do |pair|
        stop = pair[0]
        distance = pair[1]
        sors = Repository::For[Entity::StopOfRoute].find_stop_id(stop.id)
        sors.map do |sor|
          result_start << [sor.sub_route_id, stop, distance]
        end
      end
      result_start.each_with_index do |r1, i1|
        result_start.each_with_index do |r2, i2|
          if i2 != i1
            if r1[0] == r2[0]
              result_start.delete(r2) if r1[2] < r2[2]
            end
          end
        end
      end
      dest_lat = input[:result][2]
      dest_lng = input[:result][3]
      dest = Entity::FindNearestStops.new(all_of_stops)
      dest.initialize_location(dest_lat, dest_lng)
      d_piars_of_stopdis = dest.find_top_nearest_stops
      result_dest = []
      d_piars_of_stopdis.map do |pair|
        stop = pair[0]
        distance = pair[1]
        sors = Repository::For[Entity::StopOfRoute].find_stop_id(stop.id)
        sors.map do |sor|
          result_dest << [sor.sub_route_id, stop, distance]
        end
      end
      result_dest.each_with_index do |r1, i1|
        result_dest.each_with_index do |r2, i2|
          if i2 != i1
            if r1[0] == r2[0]
              result_dest.delete(r2) if r1[2] < r2[2]
            end
          end
        end
      end
      result = [result_start, result_dest]
      Right(result: result)
    end

    def get_match_sub_route(input)
      start_set = input[:result][0]
      dest_set = input[:result][1]
      # puts "#{start_set.size} #{dest_set.size}"
      match_set = []
      start_set.each do |s_item|
        dest_set.each do |d_item|
          if d_item[0] == s_item[0]
            match_set << [s_item[0], s_item[1], d_item[1], s_item[2] + d_item[2]]
          end
        end
      end
      match_sort = {}
      match_set.each do |item|
        match_sort[item[3]] = [item[0], item[1], item[2]]
      end
      match_sort = match_sort.sort_by { |_key, value| _key }.to_h
      match_sort.map do |_key, value|
        # puts _key
      end

      right_squence = []
      match_sort.values.each do |m|
        start_stops_for_squence = Repository::For[Entity::StopOfRoute].find_sub_route_id_and_stop_id(m[0],m[1].id)
        dest_stops_for_squence = Repository::For[Entity::StopOfRoute].find_sub_route_id_and_stop_id(m[0],m[2].id)
        start_stops_for_squence.each do |s_stop|
          dest_stops_for_squence.each do |d_stop|
            # puts "start #{s_stop.stop_sequence} dest #{d_stop.stop_sequence}"
            if s_stop.stop_sequence < d_stop.stop_sequence
              right_squence << m
              # puts "start #{s_stop.stop_sequence} dest #{d_stop.stop_sequence}"
            end
            # puts "--------"
          end
        end
      end
      possibleSubRoutes = []
      right_squence.map do |match|
        all_stop_of_sub_route = Repository::For[Entity::StopOfRoute].find_all_stop_of_a_sub_route(match[0])
        possibleSubRoutes << Entity::PossibleSubRoute.new(
          start_stop: match[1],
          dest_stop: match[2],
          stops_of_sub_route: all_stop_of_sub_route
        )
      end
      final = possibleSubRoutes.first 5
      Right(result: final)
    end
  end
end
