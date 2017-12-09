# frozen_string_literal: true

module TaiGo
  # for cal dist
  module Tool
    class CalDistance
      include Math
      def initialize(pin_lat, pin_lng)
        @pin_lat = pin_lat.to_f
        @pin_lng = pin_lng.to_f
      end
=begin
      def cal_distance(stop_lat, stop_lng)
        lat_diff = (@pin_lat - stop_lat) * PI / 180.0
        lng_diff = (@pin_lng - stop_lng) * PI / 180.0
        lat_sin = Math.sin(lat_diff / 2.0)**2
        lng_sin = Math.sin(lng_diff / 2.0)**2
        first = Math.sqrt((lat_sin + Math.cos(@pin_lat * PI / 180.0) * Math.cos(@pin_lng * PI / 180.0) * lng_sin).abs)
        result = Math.asin(first) * 2 * 6378137.0
        result
      end
=end
      def cal_distance(stop_lat, stop_lng)
        lat_diff = (@pin_lat - stop_lat)**2
        lng_diff = (@pin_lng - stop_lng)**2
        result = (lat_diff + lng_diff)**0.5
        result
      end
    end
  end
end
