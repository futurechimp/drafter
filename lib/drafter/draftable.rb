module Drafter
  # Adds a flag to determine whether a model class is draftable.
  module Draftable
    extend ActiveSupport::Concern

    # Overrides the +draftable+ method to first define the +draftable?+ class method before
    # deferring to the original +versioned+.
    module ClassMethods
      def draftable(*args)
        super(*args)

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
