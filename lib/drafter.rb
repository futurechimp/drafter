require 'active_support/concern'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_record'

module Drafter
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :Creation
  autoload :Draft
  autoload :Draftable

  class << self
    delegate :config, :configure, :to => Draft
  end  

  module ClassMethods
  	def draftable
  		include Creation
  		include Draftable

  		has_one :draft, :as => :draftable
  	end
  end

	def save(*args)
		# do nothing
	end
end

ActiveRecord::Base.class_eval{ include Drafter }
