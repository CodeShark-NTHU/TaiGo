# frozen_string_literal: true

require 'roda'
require 'econfig'
require 'http'
require 'base64'
require 'openssl'
require 'rubygems'
require 'active_support/all'
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

        XDATE = Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
        SIGN_DATE = 'x-date: ' + XDATE
        HASH = OpenSSL::HMAC.digest('sha1', config.app_key.to_s, SIGN_DATE)
        SIGNATURE = Base64.encode64(HASH)
        # AUTH_CODE IS GH_TOKEN IN THIS PROJECT
        AUTH_CODE = 'hmac username="' + config.app_id.to_s + ', algorithm="hmac-sha1"
                    , headers="x-date", signature="' + SIGNATURE + '"'
        
        # GET / request
        routing.root do
            { 'message' => "TaiGo API v0.1 up in #{app.environment}" }
        end

        routing.on 'api' do
            # /api/v0.1 branch
            routing.on 'v0.1' do
                # /api/v0.1/stops/:city_name
                routing on 'stops', String do |city_name|
                    motc_api = TaiGo::MOTC::Api.new(AUTH_CODE,SIGNATURE)
                    stops_mapper = TaiGo::MOTC::BusStopMapper.new(api)
                    begin
                        stops = stops_mapper.load(city_name)
                    rescue
                        routing.halt(404, error:'City not found')
                    end

                    routing.is do
                        { stops.to_json }
                    end

                end

                # /api/v0.1/routes/:city_name
                routing on 'routes', String do |city_name|
                    motc_api = TaiGo::MOTC::Api.new(AUTH_CODE,SIGNATURE)
                    routes_mapper = TaiGo::MOTC::BusRouteMapper.new(api)
                    begin
                        routes = routes_mapper.load(city_name)
                    rescue
                        routing.halt(404, error:'Routes not found')
                    end

                    routing.is do
                        { routes.to_json }
                    end

                end
                
            end
        end
    end

  end
end