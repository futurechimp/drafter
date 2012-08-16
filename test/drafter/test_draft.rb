require 'helper'

class TestDraft < Minitest::Unit::TestCase

	describe "A Draft object" do
		describe "validations" do
	    subject { @draft = Draft.new }
	    it { must have_valid(:data).when({:foo => "bar"}) }
	    it { wont have_valid(:data).when(nil) }
		end

		describe "associations" do
			it "should belong_to a :draftable"		
		end

	end

	describe "Approving a draft" do
		before do
			@article = Article.new(:text => "initial text")
		end

		describe "for an article which hasn't yet been saved" do
			before do
				@article_count = Article.count 
				@draft = @article.save_draft
				@draft_count = Draft.count
				@article = @draft.approve!
			end

			it "should create an article" do
				assert_equal(@article_count + 1, Article.count)
			end

			it "should return the saved article" do
				assert_equal(Article, @article.class)
			end
			# it "should properly populate all the attributes"
			# it "should delete the article's draft"
		end

		describe "for an object which already exists" do
			before do
				@article.save
				@article.text = "some draft text"
				@article.save_draft
			end

			it "should save the object"
			it "should properly populate all the attributes"
		end
	end

end