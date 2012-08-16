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

  private

  	# @return the existing draftable object, or a new one of the proper
  	# 	type, with attributes and files hanging off it.
  	def build_draftable
  		dr = draftable.nil? ? self.draftable_type.constantize.new : draftable
      restore_attrs_on(dr)
      restore_files_on(dr)
      dr
  	end

    # @param [Draftable] a new or existing draftable to restore from the
    #   draft attributes.
    # @return [Draftable] the draftable object populated with the draft attrs.
    def restore_attrs_on(dr)
      draftable_columns.each do |key|
        dr.raw_write_attribute key, self.data[key]
      end
      dr
    end

    def restore_files_on(dr)
    end

  	# We don't want to copy all the draft's columns into the draftable
  	# objects attributes.
  	#
  	# @return [Array] the draft's columns minus :id, :created_at, :updated_at
    def draftable_columns
    	self.data.keys - ['id', 'created_at', 'updated_at']
    end
end