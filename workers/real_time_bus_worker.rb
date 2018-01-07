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
    request = TaiGo::RealTimeBusRequestRepresenter.new(OpenStruct.new).from_json worker_request
    # while (true)
    #   bpos_mapper = TaiGo::MOTC::BusPositionMapper.new(TaiGo::Api.config)
    #   positions = bpos_mapper.load(request.city_name, request.route_name)
    #   p = TaiGo::BusPositionsRepresenter.new(Positions.new(positions))
    #   publish(request.id, p)
    #   sleep(60)
    # end
    @lat = 24.800575
    @lng = 120.9485
    #藍線1區
    5.times do
      position = TaiGo::Entity::BusPosition.new(
        plate_numb: '098-FN',
        sub_route_id: 'HSZ001001',
        coordinates: TaiGo::MOTC::BusPositionMapper::DataMapper::Coordinates.new(@lat, @lng),
        speed: 0.0,
        azimuth: 184.0,
        duty_status: 0,
        bus_status: 0
      )
      @lat = @lat + 0.1
      @lng = @lng + 0.1
      p = TaiGo::BusPositionsRepresenter.new(Positions.new([position]))
      publish(request.id, p)
      sleep(1)
    end
  end

  private

  def publish(channel_id, positions)
    channel_id = 5000
    puts "Posting update for: #{channel_id}"
    # puts positions.to_json
    HTTP.headers(content_type: 'application/json')
        .post(
          "#{RealTimeBusWorker.config.API_URL}/faye",
          body: {
            channel: "/#{channel_id}",
            data: {message: "Hello world"}
          }.to_json
        )
  end
end
