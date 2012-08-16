module Drafter

	# Takes care of associating and creating Draft objects for the draftable class.
  module Creation
    extend ActiveSupport::Concern

    # Associate a Draft object.
    included do
      has_one :draft, :as => :draftable
    end

    # Build and save the draft when told to do so.
    def save_draft
      self.build_draft(:data => self.attributes)
      self.draft.save!
      self.draft
    end

  end
end
