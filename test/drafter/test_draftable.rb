require 'helper'

class TestDraftable < MiniTest::Unit::TestCase

	describe "A draftable ActiveRecord class" do
		describe "with a :draftable_title" do
			describe "instantiating" do
				it "works" do
					assert Article.new
				end
			end
		end

		it "should know it's draftable" do
			assert Article.draftable?
		end
	end

	describe "A non-draftable ActiveRecord class" do
		it "should know it's not draftable" do
			refute User.draftable?
		end
	end

end