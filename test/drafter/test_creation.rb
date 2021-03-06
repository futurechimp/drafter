require 'helper'

class TestCreation < Minitest::Unit::TestCase

	describe "Saving a draft of" do
		describe "a new draftable article" do
			before do
				@article_count = Article.count
				@draft_count = Draft.count
				@draft_upload_count = DraftUpload.count
				@article = Article.new(
					:text => "original text",
					:upload => file_upload
				)
				@draft = @article.save_draft
			end

			it "should not create a new draftable" do
				assert_equal(@article_count, Article.count)
			end

			it "should create a saved draft object" do
				assert_equal(@draft_count + 1, Draft.count)
			end

			it "should return the @draft object" do
				assert_equal(Draft, @draft.class)
			end

			it "should save the contents of the :text attribute" do
				assert_equal "original text", @draft.data["text"]
			end

			it "should create a DraftUpload object" do
				assert_equal(@draft_upload_count + 1, DraftUpload.count)
			end

			it "should add the draft_upload to the Draft's array of them" do
				assert_equal(1, @draft.draft_uploads.length)
				assert_equal(DraftUpload.last, @draft.draft_uploads.first)
			end

			describe "a second time" do
				before do
					@article_count = Article.count
					@draft_count = Draft.count
					@draft_upload_count = DraftUpload.count
					@article.text = "updated text"
					@article.upload = file_upload("bar.txt")
					@draft = @article.save_draft
				end

				it "should not create a new Article" do
					assert_equal(@article_count, Article.count)
				end

				it "should update the Draft in place" do
					assert_equal(@draft_count, Draft.count)
				end

				it "should update the DraftUpload in place" do
					assert_equal(@draft_upload_count, DraftUpload.count)
				end
			end
		end

		describe "an existing draftable article" do
			before do
				@draft_count = Draft.count
				@draft_upload_count = DraftUpload.count
				@article = Article.create!(:text => "original text")
				@article.text = "draft text"
			end

			describe "with a file upload" do
				before do
					@article.upload = file_upload
					@draft = @article.save_draft
				end

				describe "the article" do
					it "should still have text of 'original text'" do
						assert_equal("original text", @article.reload.text)
					end

					it "should have a draft attached" do
						assert_equal(Draft, @article.draft.class)
					end

					it "should create a new draft" do
						assert_equal(@draft_count + 1, Draft.count)
					end
				end

				describe "the article's draft" do
					it "has a serialized :text attribute with content 'draft text'" do
						assert_equal('draft text', @article.draft.data["text"])
					end

					it "should create a DraftUpload object" do
						assert_equal(@draft_upload_count + 1, DraftUpload.count)
					end

					it "should add the draft_upload to the Draft's array of them" do
						assert_equal(1, @draft.draft_uploads.length)
						assert_equal(DraftUpload.last, @draft.draft_uploads.first)
					end
				end
			end


			describe "without a file upload" do
				before do
					@draft = @article.save_draft
				end

				describe "the article" do
					it "should still have text of 'original text'" do
						assert_equal("original text", @article.reload.text)
					end

					it "should have a draft attached" do
						assert_equal(Draft, @article.draft.class)
					end

					it "should create a new draft" do
						assert_equal(@draft_count + 1, Draft.count)
					end
				end

				describe "the article's draft" do
					it "has a serialized :text attribute with content 'draft text'" do
						assert_equal('draft text', @article.draft.data["text"])
					end
				end
			end
		end

		describe "an invalid article" do
			before do
				@draft_count = Draft.count
				@draft_upload_count = DraftUpload.count
				@article = Article.create!(:text => "original text")
				@article.text = ""
				@article.upload = file_upload
				@draft = @article.save_draft
			end

			it "should not create a Draft object" do
				assert_equal(@draft_count, Draft.count)
			end

			it "should not create a DraftUpload object" do
				assert_equal(@draft_upload_count, DraftUpload.count)
			end

			it "sets up validation errors on the @article" do
				assert_equal(1, @article.errors.count)
			end
		end

		# We may need to save this for later.
		#
		# If we could get these tests working, we could call save_draft on any
		# object in an association chain and have it save properly both up and
		# down the chain.
		#
		# For the moment, it should work if you save from the top of the chain.
		# Given the time constraints right now, let's use that.
		#
		# describe "a class which may belongs_to something else, e.g. a Comment" do
			# describe "when no associated class is set, e.g. there's no Article" do
			# 	before do
			# 		@comment = Comment.new(:text => "foo")
			# 		@draft_count = Draft.count
			# 		@comment.save_draft
			# 	end

			# 	it "should save a draft" do
			# 		assert_equal(@draft_count + 1, Draft.count)
			# 	end
			# end

			# describe "when there's an article" do
			# 	before do
			# 		@article = Article.create(:text => "I'm an article")
			# 		@comment = Comment.new(:text => "I belong to the article")
			# 		@comment.article = @article
			# 		@draft_count = Draft.count
			# 		@comment.save_draft
			# 	end

				# it "should save a draft" do
				# 	assert_equal(@draft_count + 1, Draft.count)
				# end

			# 	it "should add the @comment to the @article's subdrafts" do
			# 		assert @article.draft.subdrafts.include? Draft.last
			# 	end
			# end
		# end
	end

end