require 'helper'
require 'debugger'

class TestDrafter < MiniTest::Unit::TestCase
  
	describe "Saving a draft of" do
		describe "a new draftable article" do
			before do
				@article_count = Article.count
				@draft_count = Draft.count
				@article = Article.new(:text => "original text")
				@article.save_draft
			end

			it "should not create a new draftable" do
				assert_equal(@article_count, Article.count)
			end

			it "should create a saved draft object" do
				assert_equal(@draft_count + 1, Draft.count)				
			end
		end

		describe "an existing draftable article" do
			before do
				@draft_count = Draft.count
				@article = Article.create!(:text => "original text")
				@article.text = "draft text"
				@article.save_draft
			end

			describe "the article" do
				it "should still have text of 'original text'" do
					assert_equal("original text", @article.reload.text)
				end

				it "should have a draft attached" do
					assert_equal(Draft, @article.draft.class)
				end

				it "should create a new draft" do
					assert_equal(@draft_count + 1, Draft.count)
				end
			end

			describe "the article's draft" do
				it "has a serialized :text attribute with content 'draft text'" do
					assert_equal('draft text', @article.draft.data["text"])
				end
			end
		end
	end

	describe "A draftable ActiveRecord class" do
		it "should know it's draftable" do
			assert Article.draftable?
		end
	end

	describe "A non-draftable ActiveRecord class" do
		it "should know it's not draftable" do
			refute Comment.draftable?
		end
	end

end
