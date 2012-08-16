# Define models we can test with

# A draftable article class
class Article < ActiveRecord::Base

	draftable

end


# A non-draftable comment class
class Comment < ActiveRecord::Base
end