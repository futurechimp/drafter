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
      attrs = self.attributes
      uploads = build_draft_uploads(attrs)
      self.build_draft(:data => attrs)
      self.draft.save!
      self.draft.draft_uploads << uploads
      self.draft
    end

    private

      # Loop through and create DraftUpload objects for any Carrierwave
      # uploaders mounted on this draftable object.
      #
      # @param [Hash] attrs the attributes to loop through
      # @return [Array<DraftUpload>] an array of unsaved DraftUpload objects.
      def build_draft_uploads(attrs)
        draft_uploads = []
        attrs.keys.each do |key|
          if self.send(key).is_a?(CarrierWave::Uploader::Base)
            draft_uploads << build_draft_upload(key)
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
        file = File.new(cw_uploader.file.path)
        draft_upload = DraftUpload.new(
          :file_data => file, :draftable_mount_column => key)
      end

  end
end
