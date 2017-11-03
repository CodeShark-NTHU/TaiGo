# frozen_string_literal: false

require 'http'
require 'base64'
require 'openssl'

module TaiGo
  # MINISTRY OF TRANSPORTATION AND COMMUNICATIONS
  module MOTC
    # Gateway class to talk to MOTC API
    class Api
      module Errors
        # Not allowed to access resource
        ServerError = Class.new(StandardError)
        # Requested resource not found
        NotFound = Class.new(StandardError)
      end

      # Encapsulates API response success and errors
      class Response
        HTTP_ERROR = {
          500 => Errors::ServerError,
          404 => Errors::NotFound
        }.freeze

        def initialize(response)
          @response = response
        end

        def successful?
          HTTP_ERROR.keys.include?(@response.code) ? false : true
        end

        def response_or_error
          successful? ? @response : raise(HTTP_ERROR[@response.code])
        end
      end

      # def initialize(auth_code, xdate)
      #   @auth_code = auth_code
      #   @xdate = xdate
      # end

      def initialize(app_id, app_key)
        @app_id = app_id
        @app_key = app_key
      end

      def city_bus_stops_data(city_name)
        city_bus_stops_req_url = Api.city_bus_path(city_name)
        call_motc_url(city_bus_stops_req_url).parse
      end

      def city_bus_route_data(city_name)
        city_bus_route_req_url = Api.city_route_path(city_name)
        call_motc_url(city_bus_route_req_url).parse
      end

      def self.city_bus_path(path)
        'http://ptx.transportdata.tw/MOTC/v2/Bus/Stop/City/' + path
      end

      def self.city_route_path(path)
        'http://ptx.transportdata.tw/MOTC/v2/Bus/Route/City/' + path
      end

      def call_motc_url(url)
        sign_date = xdate
        signature = hash(@app_key, sign_date)
        auth_code = recode(@app_id, signature)
        response = HTTP.headers('x-date' => sign_date,
                                'Authorization' => auth_code).get(url)
        Response.new(response).response_or_error
      end

      def xdate
        'x-date: ' + Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
      end

      def hash(key, sign_date)
        Base64.encode64(OpenSSL::HMAC.digest('sha1', key, sign_date))
      end

      def recode(app_id, signature)
        'hmac username="' + app_id + '", algorithm="hmac-sha1", headers="x-date", signature="' + signature + '"'
      end
    end
  end
end
