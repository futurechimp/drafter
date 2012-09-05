require 'helper'

class TestCreation < Minitest::Unit::TestCase

  describe "Applying a draft" do
    before do
		  @article = Article.new(
			  :text => "initial text",
			  :upload => file_upload)
    end

    describe "for an unsaved article" do
      before do
        @draft = @article.save_draft
      end

      describe "with no comments" do
        before do
          @article = @draft.build_draftable
          @article.apply_draft
        end

        it "should restore the article, unsaved" do
          assert @article.new_record?
          assert_equal(Article, @article.class)
        end
      end

      describe "with comments" do
        before do
          @article = @draft.build_draftable
          @article.comments.build(:text => "I'm a comment on a draft article")
          @draft = @article.save_draft
          @article = @draft.build_draftable
        end

        it "should restore the article, unsaved" do
          assert @article.new_record?
          assert_equal(Article, @article.class)
        end

        it "should restore the comments" do
          assert_equal(1, @article.comments.length)
        end
      end
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

        describe "which has two subdrafts attached" do
          before do
            @article.comments.build(:text => "I'm a comment", :upload => file_upload)
            @article.comments.build(:text => "I'm another comment", :upload => file_upload("bar.txt"))
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
              assert_equal(2, @reloaded.comments.length)
            end

            it "should properly restore the first file, foo.txt" do
              assert_equal(file_upload.read, File.new(@reloaded.comments.first.upload.path).read)
            end

            it "should properly restore the second file, bar.txt" do
              assert_equal(file_upload("bar.txt").read, File.new(@reloaded.comments.last.upload.path).read)
            end
          end
        end
      end
    end
  end

end