# frozen_string_literal: true

require 'roda'
require 'benchmark'
require 'concurrent'
module TaiGo
  # TaiGo Web API
  class Api < Roda
    plugin :all_verbs
    plugin :multi_route
    # plugin :environments
    # plugin :json
    # plugin :halt

    require_relative 'bus'
    require_relative 'stop'
    require_relative 'route'
    require_relative 'sub_route'
    require_relative 'positions'
    require_relative 'search'

    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET / request
      routing.root do
        message = "TaiGo API v0.1 up in #{Api.environment} mode"
        HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
      end

      routing.on 'api' do
        # /api/v0.1 branch
        routing.on 'v0.1' do
          @api_root = '/api/v0.1'
          routing.multi_route

          routing.on 'concurrency' do
            routing.is do
              cities = %w[Taichung Kaohsiung Tainan Hsinchu]
              # cities = %w[Hsinchu Taichung]

              def insert_all(cities)
                cities.map do |city_name|
                  Repository::For[Entity::BusStop].delete_all(city_name)
                end
                cities.map do |city_name|
                  LoadFromMotcStop.new.call(config: app.config,
                                            city_name: city_name)
                end
              end

              def insert_all_concurrency(cities)
                cities.map do |city_name|
                  Repository::For[Entity::BusStop].delete_all(city_name)
                end
                cities.map do |city_name|
                  Concurrent::Promise
                    .new { LoadFromMotcStop.new.call(config: app.config, city_name: city_name) }
                    .then { |res| { city_name: city_name, code: res.status, body: res.body.to_s } }
                    .rescue { { error: "#{city_name} could not be loaded" } }
                end.map(&:execute).map(&:value)
              end

              # puts Benchmark.measure { insert_all(cities) }
              # puts Benchmark.measure { insert_all_concurency(cities) }
              Benchmark.bm(10) do |bench|
                bench.report('sync') { insert_all(cities) }
                bench.report('concurent:') { insert_all_concurrency(cities) }
              end
            end
          end
        end
      end
    end
  end
end
