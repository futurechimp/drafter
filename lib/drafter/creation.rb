module Drafter

	# Takes care of associating and creating Draft objects for the draftable
  # class.
  module Creation
    extend ActiveSupport::Concern

    # Set up the association to the Draft object.
    included do
      has_one :draft, :as => :draftable
    end

    # Build and save the draft when told to do so.
    def save_draft
      if self.valid?
        serialize_attributes_to_draft
        unfuck_sti
        create_subdrafts
        self.draft.save!
        build_draft_uploads
        self.draft
      end
    end

    private

      # https://github.com/rails/rails/issues/617
      def unfuck_sti
        draft.draftable_type = self.class.to_s
      end

      # Set up the draft object, setting its :data attribute to the serialized
      # hash of this object's attributes.
      #
      def serialize_attributes_to_draft
        if self.draft
          draft.data = self.attributes
        else
          self.build_draft(:data => self.attributes)
        end
      end

      # Loop through and create DraftUpload objects for any Carrierwave
      # uploaders mounted on this draftable object.
      #
      # @param [Hash] attrs the attributes to loop through
      # @return [Array<DraftUpload>] an array of unsaved DraftUpload objects.
      def build_draft_uploads
        draft_uploads = []
        self.attributes.keys.each do |key|
          if self.respond_to?(key) && self.send(key).is_a?(CarrierWave::Uploader::Base)
            self.draft.draft_uploads << build_draft_upload(key)
          end
        end
        draft_uploads
      end

      # Get a reference to the CarrierWave uploader mounted on the
      # current draftable object, grab the file in it, and shove
      # that file into a new DraftUpload.
      #
      # @param [String] key the attribute where the CarrierWave uploader
      #   is mounted.
      # @return [DraftUpload] containing the file in the uploader.
      def build_draft_upload(key)
        cw_uploader = self.send(key)
        file = File.new(cw_uploader.file.path) if cw_uploader.file
        existing_upload = self.draft.draft_uploads.where(:draftable_mount_column => key).first
        draft_upload = existing_upload.nil? ? DraftUpload.new : existing_upload
        draft_upload.file_data = file
        draft_upload.draftable_mount_column = key
        draft_upload
      end

  end
end
