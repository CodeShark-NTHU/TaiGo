# frozen_string_literal: true

<<<<<<< HEAD
folders = %w[entities lib config infrastructure]
=======
folders = %w[config entities lib infrastructure]
>>>>>>> bdd903bcec98e835d74bd70018e80eac4235b137
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end

require_relative 'app.rb'
