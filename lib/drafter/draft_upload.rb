class DraftUpload < ActiveRecord::Base

	validates_presence_of :original

	mount_uploader :original, DraftUploader

end