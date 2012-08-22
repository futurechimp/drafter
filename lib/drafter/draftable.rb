module Drafter
  # Adds a flag to determine whether a model class is draftable.
  module Draftable
    extend ActiveSupport::Concern

    # Overrides the +draftable+ method to define the +draftable?+ class method.
    module ClassMethods
      def draftable(options)

        cattr_accessor :draftable_draft_title
        self.draftable_draft_title = options[:draft_title]

        class << self
          def draftable?
            true
          end
        end
      end

      # For all ActiveRecord::Base models that do not call the +draftable+ method, the +draftable?+
      # method will return false.
      def draftable?
        false
      end
    end

  end
end
