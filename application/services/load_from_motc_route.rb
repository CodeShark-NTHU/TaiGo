# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to load repo from Github and save to database
  class LoadFromMotcRoute
    # include Dry::Transaction

    # step :get_routes_from_motc
    # step :check_if_routes_already_loaded
    # step :store_routes_in_repository

    # def get_routes_from_motc(input)
    #   routes = TaiGo::MOTC::BusRouteMapper.new(input[:config])
    #                                       .load(input[:city_name])
    #   Right(routes: routes)
    # rescue StandardError
    #   Left(Result.new(:bad_request, 'Routes not found'))
    # end

    # def check_if_routes_already_loaded(input)
    #   input[:routes].map do |route|
    #   if Repository::For[route.class].find(route)
    #     Left(Result.new(:conflict, 'Repo already loaded'))
    #   else
    #     Right(route)
    #   end
    # end

    # def store_routes_in_repository(input)
    #   stored_repo = Repository::For[input[:repo].class].create(input[:repo])
    #   Right(Result.new(:created, stored_repo))
    # rescue StandardError => e
    #   puts e.to_s
    #   Left(Result.new(:internal_error, 'Could not store remote repository'))
    # end

    def self.call(input)
      routes = TaiGo::MOTC::BusRouteMapper.new(input[:config]).load(input[:city_name])
    rescue StandardError
      routing.halt(404, error: "Bus Routes at #{input[:city_name]} not found")
    end
  end
end
