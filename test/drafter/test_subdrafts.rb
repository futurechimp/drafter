require 'helper'

class TestSubdrafts < Minitest::Unit::TestCase

  describe "Saving an article" do
    describe "with 1 attached comment" do
      before do
        Draft.delete_all
        Comment.delete_all
        Article.delete_all
        @comment_count = Comment.count
        @article = Article.new(:text => "I'm an article.")
        @article.comments.build(:text => "What a great article!", :upload => file_upload)
        @article_count = Article.count
        @draft_count = Draft.count
        @draft_upload_count = DraftUpload.count
        @article.save_draft
        @article_draft = Draft.first
        @comment_draft = Draft.last
      end

      it "should not create a new comment" do
        assert_equal(@comment_count, Comment.count)
      end

      it "should not create a new article" do
        assert_equal(@article_count, Article.count)
      end

      it "should save drafts for the article and comment" do
        assert_equal(@draft_count + 2, Draft.count)
      end

      it "should serialize the comment draft fields properly" do
        assert @comment_draft.build_draftable.is_a? Comment
        assert_equal("What a great article!", @comment_draft.text)
      end

      it "should save a draft upload for the comment's uploaded file" do
        assert_equal(@draft_upload_count + 1, DraftUpload.count)
        assert_equal(file_upload.size, File.new(@comment_draft.build_draftable.upload.path).size)
      end

      it "should correctly associate the comment draft with its parent" do
        assert_equal(@article_draft, @comment_draft.parent)
      end
    end
  end
end