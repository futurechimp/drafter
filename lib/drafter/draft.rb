class Draft < ActiveRecord::Base

	# Validations
	#
	validates_presence_of :data

	# Associations
	#
	belongs_to :draftable, :polymorphic => true


	# Store serialized data for the associated draftable
	# as a Hash of attributes.
	#
  serialize :data, Hash

  def approve!
  	draftable = self.draftable_type.constantize.new
  	draftable.save!
  end

end