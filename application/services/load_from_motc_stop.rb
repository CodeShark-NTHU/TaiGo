# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to load stops from Motc and save to database
  class LoadFromMotcStop
    include Dry::Transaction

    step :get_stops_from_motc
    step :filter_the_stops_not_in_db
    step :store_stops_in_repository

    def get_stops_from_motc(input)
      stops = TaiGo::MOTC::BusStopMapper.new(input[:config])
                                           .load(input[:city_name])
      Right(stops: stops)
    rescue StandardError
      Left(Result.new(:bad_request, 'Stops not found'))
    end
    
    def filter_the_stops_not_in_db(input)
      # only store the stops which not in db to stop_set
      stop_set = []
      input[:stops].map do |stop|
        # don't forget if we change stop uid to id ,here have to change to stop.id
        if Repository::For[stop.class].find_id(stop.uid).nil?
          stop_set << stop 
        end
      end

      if stop_set.empty?
        return Left(Result.new(:conflict, 'all of stops already loaded'))
      else
        return Right(unstored_stops: stop_set)
      end
    end

    def store_stops_in_repository(input)
      stored_stops = []
      input[:unstored_stops].map do |stop|
         stored_stops << Repository::For[stop.class].create_from(stop)
      end
      Right(Result.new(:created, stored_stops))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store remote repository'))
    end
  end
end
