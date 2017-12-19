# frozen_string_literal: true

folders = %w[values entities database_repositories motc_mappers google_map_mapper]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
