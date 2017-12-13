# frozen_string_literal: true

require_relative 'load_all'

require 'econfig'
require 'shoryuken'

# Shoryuken worker class to clone repos in parallel
class UpdateCityInfoWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, worker_request)
    request = TaiGo::BusPositionsRepresenter.new(OpenStruct.new).from_json worker_request
    puts "REQUEST: #{request}"
    # GitRepo mapper
    # gitrepo = CodePraise::GitRepo.new(request)
    # puts "EXISTS: #{gitrepo.exists_locally?}"
    # gitrepo.clone!
    # puts "REQUEST: #{request}"
    # puts "EXISTS: #{gitrepo.exists_locally?}"
  end
end
