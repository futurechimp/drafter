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

  # Approve a draft, setting the attributes of the draftable object
  # to contain the draft content, saving the draftable, and 
  # destroying the draft. 
  #
  def approve!
  	draftable = build_draftable
    draftable_columns.each do |key|
      draftable.send("#{key}=", self.data[key])
    end
  	draftable.save!
  	self.destroy
  	draftable
  end

  private

  	def build_draftable
  		draftable.nil? ? self.draftable_type.constantize.new : draftable
  	end

    def draftable_columns
    	self.data.keys - ['id', 'created_at', 'updated_at']
    end
end