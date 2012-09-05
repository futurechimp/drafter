require 'helper'

class TestSubdrafts < Minitest::Unit::TestCase

  describe "Saving a draft for an article" do
    before do
      @article = Article.new(:text => "I'm an article.")
      @article_count = Article.count
      @draft_count = Draft.count
    end

    describe "and attaching a comment" do
      before do
        @comment_count = Comment.count
        @draft_upload_count = DraftUpload.count
        @article.comments << Comment.new(:text => "What a great article!", :upload => file_upload)
        @draft = @article.save_draft
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
        assert @comment_draft.inflate.is_a? Comment
        assert_equal("What a great article!", @comment_draft.text)
      end

      it "should save a draft upload for the comment's uploaded file" do
        assert_equal(@draft_upload_count + 1, DraftUpload.count)
        assert_equal(file_upload.size, File.new(@comment_draft.inflate.upload.path).size)
      end

      it "should correctly associate the comment draft with its parent" do
        assert_equal(@article_draft, @comment_draft.parent)
      end

      describe "after calling inflate on a draft" do
        before do
          @article = @draft.inflate
        end

        it "should still have 1 comment on it" do
          assert_equal(1, @article.comments.length)
        end

        describe "restoring the draft" do
          it "should work" do
            assert (@article = @draft.inflate).is_a? Article
          end
        end

        describe "and adding another couple of comments" do
          before do
            @article.comments << Comment.new(:text => "SuperComment")
            @draft = @article.save_draft
            @article = @draft.inflate
            @article.comments << Comment.new(:text => "AnotherComment")
          end

          it "should have 3 comments" do
            assert_equal(3, @article.comments.length)
            assert_equal("SuperComment", @article.comments.second.text)
            assert_equal("AnotherComment", @article.comments.third.text)
          end
        end
      end
    end

    describe "and attaching a @like, which is a polymorphic sub-object" do
      before do
        @like_count = Like.count
        @article.save_draft
        @like = Like.new(:likeable => @article) # hack for polymorph
        @draft = @like.save_draft(@article.draft, :likes)
        @article_draft = Draft.first
        @like_draft = Draft.last
      end

      it "should save 2 new drafts" do
        assert_equal(@draft_count + 2, Draft.count)
      end

      describe "restoring the like subdraft to the article" do
        before do
          @article = @article_draft.inflate
        end

        it "should work" do
          assert_equal(1, @article.likes.length)
        end
      end

      describe "approving the article (so we start from the top of the chain)" do
        before do
          @draft_count = Draft.count
          @article_count = Article.count
          @like_count = Like.count
          @article_draft.approve!
        end

        it "should destroy the draft objects" do
          assert_equal(@draft_count - 2, Draft.count)
        end

        it "should create a new article" do
          assert_equal(@article_count + 1, Article.count)
        end

        it "should create a new Like" do
          assert_equal(@like_count + 1, Like.count)
        end
      end

    end

    describe "and attaching a polymorphic sub-object with STI" do
      before do
        @really_like_count = ReallyLike.count
        @article.save_draft
        @really_like = ReallyLike.new(:likeable => @article) # hack for polymorph
        @draft = @really_like.save_draft(@article.draft, :likes)
        @article_draft = Draft.first
        @really_like_draft = Draft.last
      end

      it "should save 2 new drafts" do
        assert_equal(@draft_count + 2, Draft.count)
      end

      describe "restoring the like subdraft to the article" do
        before do
          @article = @article_draft.inflate
        end

        it "should work, using the parent class association" do
          assert_equal(1, @article.likes.length)
        end
      end

      describe "approving the article (so we start from the top of the chain)" do
        before do
          @draft_count = Draft.count
          @article_count = Article.count
          @like_count = Like.count
          @really_like_count = ReallyLike.count
          @article_draft.approve!
        end

        it "should destroy the draft objects" do
          assert_equal(@draft_count - 2, Draft.count)
        end

        it "should create a new article" do
          assert_equal(@article_count + 1, Article.count)
        end

        it "should create a new Like" do
          assert_equal(@like_count + 1, Like.count)
        end

        it "should create a new ReallyLike" do
          assert_equal(@really_like_count + 1, ReallyLike.count)
        end
      end
    end
  end
end