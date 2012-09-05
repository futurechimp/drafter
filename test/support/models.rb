# Define models we can test with

# A draftable article class
class Article < ActiveRecord::Base
	draftable
  approves_drafts_for :comments

  has_many :comments
  has_many :likes, :as => :likeable
  has_many :really_likes

  validates_presence_of :text
	mount_uploader :upload, Uploader
end

# A draftable comment class which belongs to Article.
#
# We can use this to test out has_many associations.
class Comment < ActiveRecord::Base
  draftable

  belongs_to :article
  has_many :likes, :as => :likeable

  mount_uploader :upload, Uploader

end

# A class which allows us to test whether we can restore a polymorphic
# has_many relationship.
class Like < ActiveRecord::Base

  draftable

  belongs_to :likeable, :polymorphic => true

end

# A class which allows us to test whether we can restore a polymorphic
# has_many relationship with STI involved.
class ReallyLike < Like

end

# A non-draftable class
class User < ActiveRecord::Base
end