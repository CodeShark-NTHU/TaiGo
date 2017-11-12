# frozen_string_literal: true

folders = %w[values entities database_repositories motc_mappers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
