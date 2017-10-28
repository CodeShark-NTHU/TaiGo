require 'dry-types'

module TaiGo
  module Entity
    #Add dry types to Entity module
    module Types
      include Dry::Types.module
    end
  end
end

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end