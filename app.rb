# frozen_string_literal: true

require 'roda'
require 'econfig'
require_relative 'lib/init.rb'

module TaiGo
  # Web API
  class Api < Roda
    plugin :environments
    plugin :json
    plugin :halt

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    route do |routing|
      app = Api
      config = Api.config

      # GET / request
      routing.root do
        { 'message' => "TaiGo API v0.1 up in #{app.environment}" }
      end

      routing.on 'api' do
        # /api/v0.1 branch
        routing.on 'v0.1' do
          # /api/v0.1/stops/:city_name
          routing.on 'stops', String, String do |city_name|
            motc_api = TaiGo::MOTC::Api.new(config['motc_id'], config['motc_key'])
            stops_mapper = TaiGo::MOTC::BusStopMapper.new(motc_api)
            begin
              stops = stops_mapper.load(city_name)
            rescue StandardError
              routing.halt(404, error: 'City not found')
            end
            routing.is do
              { bus_stops: stops.map(&:to_h) }
            end
          end

          # /api/v0.1/routes/:city_name
          routing.on 'routes', String, String do |city_name|
            motc_api = TaiGo::MOTC::Api.new(config['motc_id'], config['motc_key'])
            routes_mapper = TaiGo::MOTC::BusRouteMapper.new(motc_api)
            begin
              routes = routes_mapper.load(city_name)
            rescue StandardError
              routing.halt(404, error: 'Routes not found')
            end
            routing.is do
              { bus_route: routes.map(&:to_h) }
            end
          end
        end
      end
    end
  end
end
