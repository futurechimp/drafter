puts "loaded Drafter::Creation"

module Drafter
  # Adds a flag to determine whether a model class is draftable.
  module Creation
    extend ActiveSupport::Concern

    def save_draft
      self.build_draft(:data => self.attributes)
      self.draft.save
    end

  end
end
