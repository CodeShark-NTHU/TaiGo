# frozen_string_literal: true

require_relative 'load_all'

require 'econfig'
require 'shoryuken'

# Shoryuken worker class to clone repos in parallel
class MOTCWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  # tell workers which SQS queue to listen to
  shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, worker_request)
    if worker_request == 'stops'
      stops = TaiGo::MOTC::BusStopMapper.new(@config).load(@city_name)
      not_in_db = []
      stops.map do |stop|
        not_in_db << stop if Repository::For[stop.class].find_id(stop.id).nil?
      end
      not_in_db.map do |stop|
        Repository::For[stop.class].create_from(stop)
      end
    end
  end
end
