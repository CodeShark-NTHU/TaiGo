# frozen_string_literal: true

folders = %w[database_repositories]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
