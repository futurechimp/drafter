require 'helper'

class TestSubdrafts < Minitest::Unit::TestCase

  describe "Saving an article" do
    describe "with 1 attached comment" do
      before do
        @comment = Comment.new(:text => "What a great article!")
        @comment_count = Comment.count
        @article = Article.new(:text => "I'm an article.", :comments => [@comment])
        @article_count = Article.count
        @draft_count = Draft.count
        @article.save_draft
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
    end
  end


end