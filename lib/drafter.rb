require 'active_support/concern'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_record'
require 'diffy'

require File.dirname(__FILE__) + '/drafter/draft_uploader'

module Drafter
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :Apply
  autoload :Creation
  autoload :Diffing
  autoload :Draft
  autoload :Draftable
  autoload :DraftUpload
  autoload :IdHash
  autoload :Subdrafts

  class << self
    delegate :config, :configure, :to => Draft
    delegate :config, :configure, :to => DraftUpload
  end

  included do
    include Draftable
  end

  module ClassMethods

    def draftable(options={})
      include Apply
      include Creation
      include Diffing
      include Draftable
      include IdHash
      include Subdrafts
    end

    def approves_drafts_for(*associations)
      cattr_accessor :approves_drafts_for
      self.approves_drafts_for = associations
    end
  end

end

ActiveRecord::Base.class_eval{ include Drafter }
