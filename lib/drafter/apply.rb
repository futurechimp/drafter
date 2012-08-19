module Drafter

	# Takes care of associating and creating Draft objects for the draftable
  # class.
  module Apply
    extend ActiveSupport::Concern

    # Apply the draft data to the draftable, without saving it..
    def apply_draft
      if draft
        restore_attrs
        restore_files
      end
      self
    end

    private

    # Whack the draft data onto the real object.
    #
    # @return [Draftable] the draftable object populated with the draft attrs.
    def restore_attrs
      draftable_columns.each do |key|
        self.raw_write_attribute key, self.draft.data[key]
      end
      self
    end

    # Attach draft files to the real object.
    #
    # @return [Draftable] the draftable object where CarrierWave uploads
    #   on the object have been replaced with their draft equivalents.
    def restore_files
      draft.draft_uploads.each do |draft_upload|
        self.send(draft_upload.draftable_mount_column + "=", draft_upload.file_data)
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
