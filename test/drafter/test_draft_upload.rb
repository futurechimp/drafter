require 'helper'

class TestDraftUpload < Minitest::Unit::TestCase

	describe DraftUpload do
		subject { DraftUpload.new }

		describe "validations" do
			it { must validate_presence_of :file_data }			
			it { must validate_presence_of :draft }
			it { must validate_presence_of :draftable_mount_column }
		end

		describe "associations" do
			it { must belong_to :draft }		
		end
	end

end