module Drafter
  # Adds a flag to determine whether a model class is draftable.
  module Draftable
    extend ActiveSupport::Concern

    # Overrides the +draftable+ method to define the +draftable?+ class method.
    module ClassMethods
      def draftable(options={})
        super(options)

        cattr_accessor :polymorphic_as
        self.polymorphic_as = options[:polymorphic_as]

        cattr_accessor :delegate_approval_to
        self.delegate_approval_to = options[:delegate_approval_to]

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
