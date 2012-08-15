module Drafter
  # Adds a flag to determine whether a model class is draftable.
  module Creation
    extend ActiveSupport::Concern

    included do
      after_save :create_a_draft
    end

    def create_a_draft
      draft = Draft.new(:draftable => self, :data => "blap")
      draft.save!
    end

  end
end
