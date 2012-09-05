require 'helper'

describe "Conditional id_hash output" do
  describe "for an unapproved object" do
    describe "with a draft attached" do
      before do
        @article = Article.new(:text => "I'm an article.")
        @draft = @article.save_draft
      end

      it "should give back a :draft_id" do
        assert_equal({:draft_id => @draft.to_param}, @article.id_hash)
      end
    end
  end

  describe "for a persisted object" do
    describe "with a draft attached" do
      before do
        @article = Article.create(:text => "I'm an article.")
        @article.text = "I am now an article with a draft"
        @article.save_draft
      end

      it "should give back the article's :id in a Hash" do
        assert_equal({:id => @article.to_param}, @article.id_hash)
      end
    end

    describe "with no draft attached" do
      before do
        @article = Article.create(:text => "I'm an article.")
      end

      it "should give back the article's id in a Hash" do
        assert_equal({:id => @article.to_param}, @article.id_hash)
      end
    end
  end
end

describe "Conditional id_hash_as(:foo) output" do
  describe "for an unapproved object" do
    describe "with a draft attached" do
      before do
        @article = Article.new(:text => "I'm an article.")
        @draft = @article.save_draft
      end

      it "should give back a :draft_foo_id" do
        assert_equal({:draft_foo_id => @draft.to_param}, @article.id_hash_as(:foo))
      end
    end
  end

  describe "for a persisted object" do
    describe "with a draft attached" do
      before do
        @article = Article.create(:text => "I'm an article.")
        @article.text = "I am now an article with a draft"
        @article.save_draft
      end

      it "should give back a :foo_id in a Hash" do
        assert_equal({:foo_id => @article.to_param}, @article.id_hash_as(:foo))
      end
    end

    describe "with no draft attached" do
      before do
        @article = Article.create(:text => "I'm an article.")
      end

      it "should give back the article's :foo_id in a Hash" do
        assert_equal({:foo_id => @article.to_param}, @article.id_hash_as(:foo))
      end
    end
  end
end