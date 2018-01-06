# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to load routes from Motc and save to database
  class LoadFromMotcRoute
    include Dry::Transaction

    step :get_routes_from_motc
    step :filter_the_routes_not_in_db
    step :store_routes_in_repository

    def get_routes_from_motc(input)
      routes = TaiGo::MOTC::BusRouteMapper.new(input[:config])
                                          .load(input[:city_name])
      Right(routes: routes)
    rescue StandardError
      Left(Result.new(:not_found, 'routes not found'))
    end

    def filter_the_routes_not_in_db(input)
      # only store the routes which not in db to route_set
      route_set = []

      input[:routes].map do |route|
        route_set << route if Repository::For[route.class].find_id(route.id).nil?
      end

      if route_set.empty?
        Left(Result.new(:conflict, 'all of routes already loaded'))
      else
        Right(unstored_routes: route_set)
      end
    end

    def store_routes_in_repository(input)
      stored_routes = []
      input[:unstored_routes].map do |route|
        stored_routes << Repository::For[route.class].create_from(route)
      end
      # created -> 201
      return Right(Result.new(:created, stored_routes))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store remote repository'))
    end
  end
end
