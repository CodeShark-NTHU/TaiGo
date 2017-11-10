# frozen_string_literal: true

require 'roda'
# require 'econfig'
# require_relative 'lib/init.rb'

module TaiGo
  # Web API
  class Api < Roda
    plugin :environments
    plugin :json
    plugin :halt

    # extend Econfig::Shortcut
    # Econfig.env = environment.to_s
    # Econfig.root = '.'

    route do |routing|
      app = Api
      # config = Api.config

      # GET / request
      routing.root do
        { 'message' => "TaiGo API v0.1 up in #{app.environment} mode" }
      end

      routing.on 'api' do
        # /api/v0.1 branch
        routing.on 'v0.1' do
          # /api/v0.1/route/:city_name
          routing.on 'routes', String do |city_name|
            # GET /api/v0.1/routes/:name_ch
            # routing.get do
            #   route = Repository::For[Entity::BusRoute].find_name_ch(city_name)
            #   routing.halt(404, error: 'Route not found') unless route
            #   route.to_h
            # end

            # POST '/api/v0.1/routes/:city_name
            routing.post do
              begin
                routes = TaiGo::MOTC::BusRouteMapper.new(app.config).load(city_name)
              rescue StandardError
                routing.halt(404, error: 'Routes not found')
              end
              routes.map do |route|
                stored_routes = Repository::For[route.class].find_or_create(route)
                response.status = 201
                response['Location'] = "/api/v0.1/routes/#{city_name}"
                stored_routes.to_h
              end
            end
          end
        end
      end
    end
  end
end
