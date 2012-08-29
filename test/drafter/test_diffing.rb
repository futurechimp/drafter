require 'helper'

class TestDrafter < MiniTest::Unit::TestCase

  describe "Diffing draft and live versions" do
    describe "a draftable object" do
      before do
        @article = Article.new(:text => "foo")
      end

      it "should respond_to? :differences" do
        assert @article.respond_to?(:differences)
      end

      describe "when there is no draft version" do
        it "should return nil" do
          assert_equal(nil, @article.differences(:text))
        end
      end

      describe "when there is both a draft and a persisted version" do
        before do
          @article.save!
          @article.text = "superfoo"
          @article.save_draft
        end

        describe "for a string attribute" do
          # return an html diff string for "foo" and "superfoo"
          it "should return an HTML diff between the draft and live object" do
            assert (@article.reload.differences(:text)).include?(%Q(<li class=\"del\"><del>f<strong>oo</strong></del></li>))
          end
        end
      end

    end
  end
end
