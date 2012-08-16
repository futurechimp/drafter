class Draft < ActiveRecord::Base

	# Validations
	#
	validates_presence_of :data

	# Associations
	#
  has_many :draft_uploads
	belongs_to :draftable, :polymorphic => true


	# Store serialized data for the associated draftable as a Hash of
  # attributes.
	#
  serialize :data, Hash

  # Approve a draft, setting the attributes of the draftable object to
  # contain the draft content, saving the draftable, and destroying the draft.
  #
  def approve!
  	draftable = build_draftable
  	draftable.save!
  	self.destroy
  	draftable
  end

  def method_missing(meth, *args, &block)
    if self.data.keys.include?(meth.to_s)
      self.data[meth.to_s]
    else
      super
    end
  end


  private

  	# @return the existing draftable object, or a new one of the proper
  	# 	type, with attributes and files hanging off it.
  	def build_draftable
  		dr = draftable.nil? ? self.draftable_type.constantize.new : draftable
      restore_attrs_on(dr)
      restore_files_on(dr)
      dr
  	end

    # Whack the draft data onto the real object.
    #
    # @param [Draftable] dr a new or existing draftable to restore from the
    #   draft attributes.
    # @return [Draftable] the draftable object populated with the draft attrs.
    def restore_attrs_on(dr)
      draftable_columns.each do |key|
        dr.raw_write_attribute key, self.data[key]
      end
      dr
    end

    # Attach draft files to the real object.
    #
    # @param [Draftable] dr a new or existing draftable.
    # @return [Draftable] the draftable object where CarrierWave uploads
    #   on the object have been replaced with their draft equivalents.
    def restore_files_on(dr)
      draft_uploads.each do |draft_upload|
        dr.send(draft_upload.draftable_mount_column + "=", draft_upload.file_data)
      end
    end

  	# We don't want to copy all the draft's columns into the draftable
  	# objects attributes.
  	#
  	# @return [Array] the draft's columns minus :id, :created_at, :updated_at
    def draftable_columns
    	self.data.keys - ['id', 'created_at', 'updated_at']
    end
end