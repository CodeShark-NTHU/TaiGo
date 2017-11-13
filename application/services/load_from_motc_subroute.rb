# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to load subroutes from Motc and save to database
  class LoadFromMotcSubroutes
    include Dry::Transaction

    step :get_subroutes_from_motc
    step :filter_the_subroutes_not_in_db
    step :store_subroutes_in_repository

    def get_subroutes_from_motc(input)
      subroutes = TaiGo::MOTC::BusSubRouteMapper.new(input[:config])
                                           .load(input[:city_name])
      Right(subroutes: subroutes)
    rescue StandardError
      Left(Result.new(:bad_request, 'subroutes not found'))
    end
    
    def filter_the_subroutes_not_in_db(input)
      # only store the subroutes which not in db to subroutes_set
      subroutes_set = []
      input[:subroutes].map do |subroutes|
        # don't forget if we change subroutes uid to id ,here have to change to subroutes.id
        unless Repository::For[subroutes.class].find_id(subroutes.uid).nil?
          subroutes_set << subroutes 
        end
      end

      if subroutes_set.empty?
        return Left(Result.new(:conflict, 'all of subroutes already loaded'))
      else
        return Right(Result.new(:unstored_subroutes, subroutes_set))
      end
    end

    def store_subroutes_in_repository(input)
      stored_subroutes = []
      input[:unstored_subroutes].map do |subroutes|
         stored_subroutes << Repository::For[subroutes.class].create_from(input[:subroutes])
      end
      Right(Result.new(:created subroutes, stored_subroutes))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store remote repository'))
    end
  end
end
