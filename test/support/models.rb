# Define models we can test with

# A draftable article class
class Article < ActiveRecord::Base
	draftable
  approves_drafts_for :comments

  has_many :comments
  validates_presence_of :text
	mount_uploader :upload, Uploader
end

# A draftable comment class which belongs to Article.
#
# We can use this to test out associations.
class Comment < ActiveRecord::Base
  draftable

  belongs_to :article
  mount_uploader :upload, Uploader

end

# A non-draftable class
class User < ActiveRecord::Base
end