# Define models we can test with

# A draftable article class
class Article < ActiveRecord::Base

  validates_presence_of :text

	draftable :draft_title => :text

	mount_uploader :upload, Uploader

end

class Post < ActiveRecord::Base

  draftable

end


# A non-draftable comment class
class Comment < ActiveRecord::Base
end