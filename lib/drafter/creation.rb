puts "creation loaded"

module Drafter
	module Creation
		extend ActiveSupport::Concern 

		included do
			
		end

		module InstanceMethods

			def save
				puts "fuck you!"
			end
		end
	end
end