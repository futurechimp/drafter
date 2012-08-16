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
      puts "upload count: #{uploads.length}"
      # debugger if uploads.length == 1
      self.draft.draft_uploads << uploads
      self.draft
    end

    private 

      def build_draft_uploads(attrs)
        draft_uploads = []
        attrs.keys.each do |key|
          if self.send(key).is_a?(CarrierWave::Uploader::Base)
            cw_uploader = self.send(key)
            file = File.new(cw_uploader.file.path)
            draft_upload = DraftUpload.new(
              :file_data => file, :draftable_mount_column => key)
            draft_uploads << draft_upload
          end
        end
        draft_uploads
      end

  end
end
