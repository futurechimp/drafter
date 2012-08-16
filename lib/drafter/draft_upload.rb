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