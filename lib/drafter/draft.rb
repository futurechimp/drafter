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
      puts "sending #{key} with data #{data[key]}"
      draftable.raw_write_attribute key, self.data[key]
    end
    # draftable.upload.
    puts "upload: #{draftable.upload.filename}"
  	draftable.save!
  	self.destroy
  	draftable
  end

  private

  	# @return the existing draftable object, or a new one of the proper
  	# 	type.
  	def build_draftable
  		draftable.nil? ? self.draftable_type.constantize.new : draftable
  	end

  	# We don't want to copy all the draft's columns into the draftable
  	# objects attributes.
  	#
  	# @return [Array] the draft's columns minus :id, :created_at, :updated_at
    def draftable_columns
    	self.data.keys - ['id', 'created_at', 'updated_at']
    end
end