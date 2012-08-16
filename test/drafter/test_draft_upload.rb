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

		describe "uploading files" do
			it "works" do
				draft_upload = DraftUpload.new(
					:file_data => file_upload,
					:draft => Draft.create(:data => {:foo => :bar}),
					:draftable_mount_column => :photo
				)
				assert draft_upload.save!
				assert File.exist?(draft_upload.reload.file_data.path)
			end
		end
	end

end