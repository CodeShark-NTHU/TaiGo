# frozen_string_literal: true

module TaiGo
  # for cal dist
  module Distance
    include Math
    def self.cal_dist(user_lat, user_lng, stop_lat, stop_lng)
      lat_diff = (user_lat - stop_lat) * PI / 180.0
      lng_diff = (user_lng - stop_lng) * PI / 180.0
      lat_sin = Math.sin(lat_diff / 2.0)**2
      lng_sin = Math.sin(lng_diff / 2.0)**2
      first = Math.sqrt(lat_sin + Math.cos(user_lat * PI / 180.0) * Math.cos(user_lng * PI / 180.0) * lng_sin)
      result = Math.asin(first) * 2 * 6378137.0
      result
    end
  end
end
