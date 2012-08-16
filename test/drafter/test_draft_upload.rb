require 'helper'

class TestDraftUpload < Minitest::Unit::TestCase

	describe DraftUpload do
		subject { DraftUpload.new }

		describe "validations" do
			it { must validate_presence_of :draft }
			it { must validate_presence_of :original }			
		end

		describe "associations" do
			it { must belong_to :draft }		
		end
	end

end