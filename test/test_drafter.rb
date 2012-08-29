require 'helper'

class TestDrafter < MiniTest::Unit::TestCase

  describe "A draftable class" do
    it "responds to :save_draft" do
      assert Article.new.respond_to?(:save_draft)
    end
  end

  describe "A non-draftable class" do
    it "does not respond to :save_draft" do
      refute Comment.new.respond_to?(:save_draft)
    end
  end

end
