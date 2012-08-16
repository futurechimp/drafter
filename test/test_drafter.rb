require 'helper'

class TestDrafter < MiniTest::Unit::TestCase
  
	

	describe "A draftable ActiveRecord class" do
		it "should know it's draftable" do
			assert Article.draftable?
		end
	end

	describe "A non-draftable ActiveRecord class" do
		it "should know it's not draftable" do
			refute Comment.draftable?
		end
	end

end
