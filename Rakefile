# frozen_string_literal: true

require 'rake/testtask'

task :default do
  puts `rake -T`
end

# Configuration only -- not for direct calls
task :config do
  require_relative 'config/environment.rb' # load config info
  @app = CodePraise::Api
  @config = @app.config
end

desc 'Run tests once'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

task :console do
  sh 'pry -r ./spec/test_load_all'
end

namespace :worker do
  namespace :run do
    desc 'Run the background cloning worker in development mode'
    task :development => :config do
      sh 'RACK_ENV=development bundle exec shoryuken -r ./workers/real_time_bus_worker.rb -C ./workers/shoryuken_dev.yml'
    end

    desc 'Run the background cloning worker in testing mode'
    task :test => :config do
      sh 'RACK_ENV=test bundle exec shoryuken -r ./workers/real_time_bus_worker.rb -C ./workers/shoryuken_test.yml'
    end

    desc 'Run the background cloning worker in production mode'
    task :production => :config do
      sh 'RACK_ENV=production bundle exec shoryuken -r ./workers/real_time_bus_worker.rb -C ./workers/shoryuken.yml'
    end
  end
end

namespace :vcr do
  desc 'Delete cassette fixtures'
  task :delete do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  CODE = 'lib/'

  desc 'run all quality checks'
  task all: %i[rubocop reek flog]

  task :rubocop do
    sh 'rubocop'
  end

  task :reek do
    sh "reek #{CODE}"
  end

  task :flog do
    sh "flog #{CODE}"
  end
end

namespace :queue do
  require 'aws-sdk-sqs'

  desc "Create SQS queue for Shoryuken"
  task :create => :config do
    sqs = Aws::SQS::Client.new(region: @config.AWS_REGION)

    begin
      queue = sqs.create_queue(
        queue_name: @config.CLONE_QUEUE,
        attributes: {
          FifoQueue: 'true',
          ContentBasedDeduplication: 'true'
        }
      )

      q_url = sqs.get_queue_url(queue_name: @config.CLONE_QUEUE)
      puts "Queue created:"
      puts "Name: #{@config.CLONE_QUEUE}"
      puts "Region: #{@config.AWS_REGION}"
      puts "URL: #{q_url.queue_url}"
      puts "Environment: #{@app.environment}"
    rescue => e
      puts "Error creating queue: #{e}"
    end
  end

  desc "Purge messages in SQS queue for Shoryuken"
  task :purge => :config do
    sqs = Aws::SQS::Client.new(region: @config.AWS_REGION)

    begin
      queue = sqs.purge_queue(queue_url: @config.CLONE_QUEUE_URL)
      puts "Queue #{@config.CLONE_QUEUE} purged"
    rescue => e
      puts "Error purging queue: #{e}"
    end
  end
end

namespace :db do
  require_relative 'config/environment.rb' # load config info
  require 'sequel' # TODO: remove after create orm

  Sequel.extension :migration
  app = TaiGo::Api

  desc 'Run migrations'
  task :migrate do
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'infrastructure/database/migrations')
  end

  desc 'Drop all tables'
  task :drop do
    require_relative 'config/environment.rb'
    # drop according to dependencies
    app.DB.drop_table :stop_of_routes
    app.DB.drop_table :sub_routes
    app.DB.drop_table :routes
    app.DB.drop_table :stops
    app.DB.drop_table :schema_info
  end

  desc 'Reset all database tables'
  task reset: %i[:drop :migrate]

  desc 'Delete dev or test database file'
  task :wipe do
    if app.environment == :production
      puts 'Cannot wipe production database!'
      return
    end

    FileUtils.rm(app.config.DB_FILENAME)
    puts "Deleted #{app.config.DB_FILENAME}"
  end
end
