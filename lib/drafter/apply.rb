module Drafter

  # Takes care of associating and creating Draft objects for the draftable
  # class.
  module Apply
    extend ActiveSupport::Concern

    # Build and save the draft when told to do so.
    def apply_draft
      restore_attrs
      restore_files
      self
    end


    private

    # Whack the draft data onto the real object.
    #
    # @param [Draftable] dr a new or existing draftable to restore from the
    #   draft attributes.
    # @return [Draftable] the draftable object populated with the draft attrs.
    def restore_attrs
      draftable_columns.each do |key|
        self.send key + "=", draft.data[key]
      end
    end

    # Attach draft files to the real object.
    #
    # @param [Draftable] dr a new or existing draftable.
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
      draft.data.keys - ['id', 'created_at', 'updated_at']
    end
  end
end
