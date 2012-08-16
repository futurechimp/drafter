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
      attrs = do_carrierwave_check(attrs)
      puts attrs
      self.build_draft(:data => attrs)
      self.draft.save!
      self.draft
    end

    private 

      def do_carrierwave_check(attrs)
        cw_attrs = {}
        attrs.keys.each do |key|
          if self.send(key).is_a?(CarrierWave::Uploader::Base)
            cw_attrs.merge!(key => self.send(key).filename)
          end
        end
        attrs.merge!(cw_attrs)
        attrs
      end

  end
end
