# Define models we can test with

# A draftable article class
class Article < ActiveRecord::Base

	draftable

	mount_uploader :photo, PhotoUploader

end


# A non-draftable comment class
class Comment < ActiveRecord::Base
end