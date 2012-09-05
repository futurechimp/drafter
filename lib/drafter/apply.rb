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

    def restore_subdrafts
      draft.subdrafts.each_with_index do |subdraft, index|
        inflated_object = subdraft.build_draftable
        self.send(subdraft.parent_association_name.to_sym) << inflated_object
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
