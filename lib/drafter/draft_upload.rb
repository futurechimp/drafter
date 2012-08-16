# Some of the objects we want to keep drafts of will have attached uploads, 
# which are stored using CarrierWave. The simplest thing which can work, I 
# think, is to grab the uploaded data from the draftable object, and store it 
# in its own class, making a note of the original mount column that the file 
# was destined for. 
#
# The original :file_data is saved in this model, without any processing
# or modification. When the draft is approved, the Draft will push the
# :file_data onto the :draftable_mount_column of the draftable object.
#
class DraftUpload < ActiveRecord::Base

	# Associations
	#
	belongs_to :draft

	# Validations
	#
	validates_presence_of :draft
	validates_presence_of :draftable_mount_column
	validates_presence_of :file_data

	# Macros
	#
	mount_uploader :file_data, DraftUploader

end