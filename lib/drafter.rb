require 'active_support/concern'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_record'

require File.dirname(__FILE__) + '/drafter/draft_uploader'

module Drafter
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :Creation
  autoload :Draft
  autoload :Draftable
  autoload :DraftUpload

  class << self
    delegate :config, :configure, :to => Draft
    delegate :config, :configure, :to => DraftUpload
  end

  included do
  	include Creation
    include Draftable
  end

end

ActiveRecord::Base.class_eval{ include Drafter }
