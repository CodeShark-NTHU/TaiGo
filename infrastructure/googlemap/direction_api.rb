# frozen_string_literal: false

require 'http'
require 'google_maps_service'

module TaiGo
  module GoogleMap
    # Gateway class to talk to GoogleMap API
    class Api
      def initialize(token, retry_timeout, queries_per_second)
        # Setup global parameters
        # 'AIzaSyBjcKDMFDmdZyzd-XjqQADKoaht2UNxNvM'
        GoogleMapsService.configure do |config|
          config.key = token
          config.retry_timeout = retry_timeout
          config.queries_per_second = queries_per_second
        end
        # Initialize client using global parameters
        @gmaps = GoogleMapsService::Client.new
      end

      def direction_data(startlocation, endlocation)
        # Simple directions
        routes = @gmaps.directions(
          startlocation.to_s,
          endlocation.to_s,
          mode: 'transit',
          language: 'zh-TW', #en zh-TW
          alternatives: true)
        routes
      end
    end
  end
end
