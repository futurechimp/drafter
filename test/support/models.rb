# Define models we can test with

# A draftable article class
class Article < ActiveRecord::Base

  validates_presence_of :text

	draftable

	mount_uploader :upload, Uploader

end


# A non-draftable comment class
class Comment < ActiveRecord::Base
end