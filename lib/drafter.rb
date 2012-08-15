require 'active_support/concern'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_record'

puts "Drafter loaded"

module Drafter
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  # load File.dirname(__FILE__) + '/drafter/creation.rb'
  # autoload :Retrieval

  module ClassMethods
  	def draftable
  		# include Creation

  		# has_one :draft
  	end
  end

	def save
		# do nothing
	end
end

ActiveRecord::Base.class_eval{ include Drafter }
