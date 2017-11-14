# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to load subroutes from Motc and save to database
  class LoadFromMotcSubRoute
    include Dry::Transaction

    step :get_subroutes_from_motc
    step :filter_the_subroutes_not_in_db
    step :store_subroutes_in_repository

    def get_subroutes_from_motc(input)
      subroutes = TaiGo::MOTC::BusSubRouteMapper.new(input[:config])
                                                .load(input[:city_name])
      Right(subroutes: subroutes)
    rescue StandardError
      Left(Result.new(:not_found, 'subroutes not found'))
    end

    def filter_the_subroutes_not_in_db(input)
      # only store the subroutes which not in db to subroutes_set
      subroutes_set = []
      input[:subroutes].map do |subroute|
        # if we change subroutes uid to id ,here have to change to subroute.id
        subroutes_set << subroute if Repository::For[subroute.class]
                                     .find_id(subroute.id).nil?
      end

      if subroutes_set.empty?
        Left(Result.new(:conflict, 'all of subroutes already loaded'))
      else
        Right(unstored_subroutes: subroutes_set)
      end
    end

    def store_subroutes_in_repository(input)
      stored_subroutes = []
      input[:unstored_subroutes].map do |subroute|
        stored_subroutes << Repository::For[subroute.class]
                            .create_from(subroute)
      end
      Right(Result.new(:created, stored_subroutes))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store remote repository'))
    end
  end
end
