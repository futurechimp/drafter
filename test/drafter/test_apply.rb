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

        describe "which has a subdraft attached" do
          before do
            @article.comments.build(:text => "I'm a comment", :upload => file_upload)
            @draft_count = Draft.count
            @article.save_draft
            @reloaded = Article.find(@article.to_param)
          end

          it "should not yet have any comments attached" do
            assert_equal(0, @reloaded.comments.length)
          end

          describe "applying the draft" do
            before do
              @reloaded.apply_draft
            end

            it "should be able to restore the comment" do
              assert_equal(1, @reloaded.comments.length)
            end
          end

        end
      end
    end
  end

end