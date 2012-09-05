module Drafter

	# Applies draft data to draftable objects.
  module Apply
    extend ActiveSupport::Concern

    # Apply the draft data to the draftable, without saving it.
    def apply_draft
      if draft
        restore_attrs
        restore_files
        restore_subdrafts
      end
      self
    end

    private

    # Whack the draft data onto the real object.
    #
    # @return [Draftable] the draftable object populated with the draft attrs.
    def restore_attrs
      draftable_columns.each do |key|
        self.send "#{key}=", self.draft.data[key] if self.respond_to?(key)
      end
      self
    end

    # Attach draft files to the real object.
    #
    # @return [Draftable] the draftable object where CarrierWave uploads
    #   on the object have been replaced with their draft equivalents.
    def restore_files
      draft.draft_uploads.each do |draft_upload|
        uploader = draft_upload.draftable_mount_column
        self.send(uploader + "=", draft_upload.file_data)
      end
    end

    # It's possible to easily restore subdrafts except in one case we've
    # run into so far: the case where you try to restore a subdraft which
    # is defined using Single Table Inheritance (STI) and which also has a
    # polymorphic belongs_to relationship with the draftable class.
    #
    # In those edge cases, we need to do a dirty little hack, using the
    # :polymorphic_as option from the class's draftable method to manually
    # set the association.
    #
    # This won't be clear enough to make sense 5 minutes from now, so here are
    # the details spelled out more concretely. Let's say you've got these
    # classes:
    #
    # class Article < ActiveRecord::Base
    #   draftable
    #   has_many :likes, :as => :likeable
    #   has_many :really_likes
    # end
    #
    # class Like < ActiveRecord::Base
    #   draftable
    #   belongs_to :likeable, :polymorphic => true
    # end
    #
    # class ReallyLike < Like
    # end
    #
    # This setup will actually work fine for subdraft restoration, right up
    # until you add "validates_presence_of :likeable" to Like. At that point,
    # you'll be told that really_likes is invalid whenever you try to approve
    # something, because the polymorphic STI "really_likable" won't be able
    # to figure out what its likeable id is when it saves during the approval
    # process.
    #
    # The hack basically involves explicitly telling draftable in the Like
    # class what its polymorph relation is:
    #
    # class Like < ActiveRecord::Base
    #   draftable :polymorphic_as => :likeable
    #   ...
    #
    # See the models setup at tests/support/models.rb for the working setup.
    #
    def restore_subdrafts
      draft.subdrafts.each_with_index do |subdraft, index|
        inflated_object = subdraft.inflate
        self.send(subdraft.parent_association_name.to_sym) << inflated_object
        # THE HACK
        if inflated_object.class.polymorphic_as
          inflated_object.send("#{inflated_object.class.polymorphic_as}=", self)
        end
      end
    end

  	# We don't want to copy all the draft's columns into the draftable
  	# objects attributes.
  	#
  	# @return [Array] the draft's columns minus :id, :created_at, :updated_at
    def draftable_columns
    	self.draft.data.keys - ['id', 'created_at', 'updated_at']
    end

  end
end
