require 'helper'
require 'debugger'

class TestDrafter < MiniTest::Unit::TestCase
  
	describe "Saving a draftable article" do
		# before do
		# 	@article = Article.new(:text => "foo")
		# end
		# describe "the first time" do
		# 	before do
		# 		@article.save
		# 	end

		# 	it "should save the article" do
		# 		refute @article.new_record?
		# 	end

		# 	it "should not create a new draft attached to the article"
		# end

		describe "for the second time" do
			before do
				@article = Article.first 
				@article.text = "bar"
				@article.save
			end

			describe "the article" do
				it "should still have text of 'foo'" do
					assert_equal("foo", @article.reload.text)
				end

				it "should have a draft attached" do
					assert_equal(Draft, @article.draft.class)
				end
			end
			describe "the article's draft" do
				it "exists"
				it "has a serialized :text attribute with content 'bar'"
			end
		end

		describe "for the third time" do
			it "should not actually save the article"
			it "should update the same draft"
			it "should leave the draft attached to the article" 
			describe "the article" do
				it "should still only have 1 draft" 
			end
		end
	end

	describe "Saving a non-draftable class" do
		it "should save normally"
	end

end
