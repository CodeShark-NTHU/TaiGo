# frozen_string_literal: true

require 'roda'

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
        # { 'message' => "TaiGo API v0.1 up in #{app.environment} mode" }
      end

      routing.on 'api' do
        # /api/v0.1 branch
        routing.on 'v0.1' do
          @api_root = '/api/v0.1'
          routing.multi_route
        end
      end
    end
  end
end
