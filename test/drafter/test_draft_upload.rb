require 'helper'

class TestDraftUpload < Minitest::Unit::TestCase

	describe DraftUpload do
		subject { DraftUpload.new }
		it { must validate_presence_of :original }
	end

end