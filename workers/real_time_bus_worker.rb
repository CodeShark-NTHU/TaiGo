# frozen_string_literal: true

require_relative 'load_all'

require 'econfig'
require 'shoryuken'


# Shoryuken worker class to clone repos in parallel
class RealTimeBusWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  # require_relative 'test_helper' if ENV['RACK_ENV'] == 'test'

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  # tell workers which SQS queue to listen to
  shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, worker_request)
    config = YAML.safe_load(File.read('config/secrets.yml'))
    config['MOTC_ID'] = config['development']['MOTC_ID']
    config['MOTC_KEY'] = config['development']['MOTC_KEY']
    request = TaiGo::RealTimeBusRequestRepresenter.new(OpenStruct.new).from_json worker_request
    while(true)
      bpos_mapper = TaiGo::MOTC::BusPositionMapper.new(config)
      positions = bpos_mapper.load(request.city_name, request.route_name)
      p = TaiGo::BusPositionsRepresenter.new(Positions.new(positions))
      publish(request.id, p, request.city_name, request.route_name)
      sleep(5)
    end
  end

  private

  def publish(channel, positions, city_name, route_name)
    puts "#{positions.to_json}"
    HTTP.headers(content_type: 'application/json')
        .post(
          "#{RealTimeBusWorker.config.API_URL}#{city_name}/#{route_name}/faye",
          body: {
            channel: "/#{channel}",
            data: positions.to_json
          }.to_json
        )
  end
end
