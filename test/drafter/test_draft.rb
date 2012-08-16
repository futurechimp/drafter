require 'helper'

class TestDraft < Minitest::Unit::TestCase

	describe "A Draft object" do
		describe "validations" do
	    subject { @draft = Draft.new }
	    it { must have_valid(:data).when({:foo => "bar"}) }
	    it { wont have_valid(:data).when(nil) }
		end

		describe "associations" do
			it "should belong_to a :draftable"		
		end

	end
end