require 'helper'

class TestDraft < Minitest::Unit::TestCase

	describe Draft do
		subject { @draft = Draft.new }
		describe "validations" do
		  it { must validate_presence_of(:data) }
		end

		describe "associations" do
			it { must belong_to(:draftable) }
			it { must have_many(:draft_uploads) }
		end
	end

	describe "Approving a draft" do
		before do
			@article = Article.new(
				:text => "initial text",
				:upload => file_upload)
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

			it "should properly populate all the attributes" do
				assert_equal("initial text", @article.text)
			end

			it "should populate all the file uploads" do
				assert_equal("foo.txt", @article.upload.filename)
				assert_equal("foo foo foo", File.open(@article.upload.path).read)
			end

			it "should delete the article's draft" do
				assert_equal(@draft_count - 1, Draft.count)
				refute @article.draft
			end
		end

		describe "for an article which already exists" do
			before do
				@article.save
				@article_count = Article.count
				@article.text = "some draft text"
				@draft = @article.save_draft
				@draft.approve!
			end

			it "shouldn't do anything mental, like creating a new object" do
				assert_equal(@article_count, Article.count)
			end

			it "should properly populate all the attributes" do
				assert_equal("some draft text", @article.text)
			end
		end
	end

end