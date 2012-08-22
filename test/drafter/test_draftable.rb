require 'helper'

class TestDraftable < MiniTest::Unit::TestCase

	describe "A draftable ActiveRecord class" do
		it "should know it's draftable" do
			assert Article.draftable?
		end

		describe "with a :draft_title argument" do
			it "should know its :draft_title field" do
				assert_equal(:text, Article.draftable_draft_title)
			end
		end
	end

	describe "A non-draftable ActiveRecord class" do
		it "should know it's not draftable" do
			refute Comment.draftable?
		end
	end

end