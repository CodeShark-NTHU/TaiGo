# frozen_string_literal: true

folders = %w[config infrastructure domain application]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end

<<<<<<< HEAD
# require_relative 'app.rb'
=======
#require_relative 'app.rb'
>>>>>>> e89966da6d9c0480f30491c2c5280397b5407f88
