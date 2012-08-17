require 'helper'

class TestCreation < Minitest::Unit::TestCase

  describe "Applying draft info to a saved object" do
    before do
      @article = Article.create!(
        :text => "initial text",
        :upload => file_upload)
      @article.text = "changed"
      @article.upload = file_upload("bar.txt")
      @draft = @article.save_draft
      @article.reload
      @article.apply_draft
    end

    it "should not save the article" do
      assert @article.changed?
    end

    it "should set the article text to the draft text" do
      assert_equal('changed', @article.text)
    end

    it "should add the 'bar.txt' upload to the article's upload" do
      assert_equal('bar.txt', @article.upload.filename)
    end

  end

end