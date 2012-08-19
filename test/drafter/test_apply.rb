require 'helper'

class TestCreation < Minitest::Unit::TestCase

  describe "Applying a draft" do
    before do
		  @article = Article.new(
			  :text => "initial text",
			  :upload => file_upload)
    end

    describe "to an existing article" do
      before do
        @article.save!
      end

      describe "when there's no draft" do
        it "should just return the article" do
          @article.apply_draft
          assert @article
        end 
      end

      describe "with a draft" do
        before do
          @article.text = "changed"
          @article.upload = file_upload("bar.txt")
          @article.save_draft
          @article.reload
          @article.apply_draft
        end

        it "should change the article without saving it" do
          assert @article.changed?
        end

        it "should apply the text change" do
          assert_equal("changed", @article.text)
        end

       it "should restore the draft upload" do
          assert_equal("bar.txt", @article.upload.filename)
        end
      end
    end
  end

end
