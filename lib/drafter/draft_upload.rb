class DraftUpload < ActiveRecord::Base

	# Associations
	#
	belongs_to :draft

	# Validations
	#
	validates_presence_of :original

	# Macros
	#
	mount_uploader :original, DraftUploader

end