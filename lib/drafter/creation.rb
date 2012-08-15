module Drafter
  # Adds a flag to determine whether a model class is draftable.
  module Creation
    extend ActiveSupport::Concern

    included do
      before_save :create_a_draft
    end

    def create_a_draft
      puts "attempting draft creation, self.id = #{self.to_param.to_s}"
      draft = Draft.create!(:draftable => self, :data => "blap")
    end

  end
end
