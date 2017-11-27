# frozen_string_literal: true

module TaiGo
  # for cal dist
  module Destination
    class FindNearestStops
    
      include Math
      NEAREST_STOP_NUM = 5 # for return to user.

      def initialize(allofstops)
        @allofstops = allofstops
      end

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
end


# frozen_string_literal: true

module CodePraise
  module Blame
    # Git blame parsing and reporting services
    class Summary
      MAX_SIZE = 1000 # for cloning, analysis, summaries, etc.

      module Errors
        TooLargeToSummarize = Class.new(StandardError)
      end

      def initialize(repo)
        @repo = repo
      end

      def too_large?
        @repo.size > MAX_SIZE
      end

      def for_folder(folder_name)
        raise TooLargeToSummarize if too_large?
        blame_reports = Blame::Reporter.new(@repo).folder_report(folder_name)
        Entity::FolderSummary.new(@repo, folder_name, blame_reports)
      end
    end
  end
