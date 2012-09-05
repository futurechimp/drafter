require 'helper'

class TestSubdrafts < Minitest::Unit::TestCase

  describe "Saving a draft for an article" do
    describe "with 1 attached comment" do
      before do
        @comment_count = Comment.count
        @article = Article.new(:text => "I'm an article.")
        @article.comments << Comment.new(:text => "What a great article!", :upload => file_upload)
        @article_count = Article.count
        @draft_count = Draft.count
        @draft_upload_count = DraftUpload.count
        @draft = @article.save_draft
        @article_draft = Draft.first
        @comment_draft = Draft.last
      end

      # it "should not create a new comment" do
      #   assert_equal(@comment_count, Comment.count)
      # end

      # it "should not create a new article" do
      #   assert_equal(@article_count, Article.count)
      # end

      # it "should save drafts for the article and comment" do
      #   assert_equal(@draft_count + 2, Draft.count)
      # end

      # it "should serialize the comment draft fields properly" do
      #   assert @comment_draft.build_draftable.is_a? Comment
      #   assert_equal("What a great article!", @comment_draft.text)
      # end

      # it "should save a draft upload for the comment's uploaded file" do
      #   assert_equal(@draft_upload_count + 1, DraftUpload.count)
      #   assert_equal(file_upload.size, File.new(@comment_draft.build_draftable.upload.path).size)
      # end

      # it "should correctly associate the comment draft with its parent" do
      #   assert_equal(@article_draft, @comment_draft.parent)
      # end

      describe "after calling build_draftable on a draft" do
        before do
          @article = @draft.build_draftable
        end

        # it "should still have 1 comment on it" do
        #   assert_equal(1, @article.comments.length)
        # end

        # describe "restoring the draft" do
        #   it "should work" do
        #     assert (@article = @draft.build_draftable).is_a? Article
        #   end
        # end

        describe "and adding another comment" do
          before do
            @article.comments << Comment.new(:text => "SuperComment")
            @draft = @article.save_draft
            @article = @draft.build_draftable
            @article.comments << Comment.new(:text => "AnotherComment")
          end

          it "should have 3 comments" do
            assert_equal(3, @article.comments.length)
            assert_equal("SuperComment", @article.comments.second.text)
            assert_equal("AnotherComment", @article.comments.second.text)
          end
        end
      end
    end
  end
end