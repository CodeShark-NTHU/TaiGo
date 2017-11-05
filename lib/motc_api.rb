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

      def initialize(app_id, app_key)
        @app_id = app_id
        @app_key = app_key
      end

      def city_bus_stops_data(city_name)
        city_bus_stops_req_url = Api.url(%W[Bus Stop City #{city_name}].join('/'))
        call_motc_url(city_bus_stops_req_url).parse
      end

      def city_bus_route_data(city_name)
        city_bus_route_req_url = Api.url(%W[Bus Route City #{city_name}].join('/') )
        call_motc_url(city_bus_route_req_url).parse
      end

      def city_stop_route_data(city_name)
        city_bus_route_req_url = Api.url(%W[Bus StopOfRoute City #{city_name}].join('/') )
        call_motc_url(city_bus_route_req_url).parse
      end

      def self.url(path)
        'http://ptx.transportdata.tw/MOTC/v2/' + path
      end

      def call_motc_url(url)
        date = time_now_gmt
        auth_code = generate_token(date)
        response = HTTP.headers('x-date' => date,
                                'Authorization' => auth_code).get(url)
        Response.new(response).response_or_error
      end

      def generate_token(date)
        signature = create_signature(@app_key, date)
        token_string(@app_id, signature)
      end

      def time_now_gmt
        Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
      end

      private

      def create_signature(key, date)
        sign_date = 'x-date: ' + date
        sign = Base64.encode64(OpenSSL::HMAC.digest('sha1', key, sign_date))
        sign.delete!("\n")
      end

      def token_string(app_id, signature)
        'hmac username="' + app_id + '", algorithm="hmac-sha1", ' \
        'headers="x-date", signature="' + signature + '"'
      end
    end
  end
end
