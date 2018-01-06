# frozen_string_literal: true

require 'faye'
require_relative './init.rb'

use Faye::RackAdapter, :mount => '/faye', :timeout => 600
run TaiGo::Api.freeze.app
