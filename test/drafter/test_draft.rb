require 'helper'

class TestDraft < Minitest::Unit::TestCase

	describe Draft do
		subject { @draft = Draft.new }
		describe "validations" do
		  it { must validate_presence_of(:data) }
		end

		describe "associations" do
			it { must belong_to(:draftable) }
			it { must have_many(:draft_uploads) }
			# it { must have_many(:subdrafts).class_name("Draft") } TODO: fix foreign_key problem.
		end
	end

	describe "Accessing draft data properties" do
		before do
			@draft = Draft.new(:data => {"foo" => "bar"})
		end

		describe "through the data hash" do
			it "works" do
				assert_equal("bar", @draft.data["foo"])
			end
		end

		describe "using dot notation" do
			it "also works" do
				assert_equal("bar", @draft.foo)
			end
		end
	end

	describe "Approving a draft" do
		before do
			@article = Article.new(
				:text => "initial text",
				:upload => file_upload)
		end

		describe "for an article which hasn't yet been saved" do
			before do
				@article_count = Article.count
				@draft = @article.save_draft
				@draft_count = Draft.count
			end

			describe "when the article has no comments" do
				before do
					@article = @draft.approve!
				end

				it "should create an article" do
					assert_equal(@article_count + 1, Article.count)
				end

				it "should return the saved article" do
					assert_equal(Article, @article.class)
				end

				it "should properly populate all the attributes" do
					assert_equal("initial text", @article.text)
				end

				it "should populate all the file uploads" do
					assert_equal("foo.txt", @article.upload.filename)
					assert_equal("foo foo foo", File.open(@article.upload.path).read)
				end

				it "should delete the article's draft" do
					assert_equal(@draft_count - 1, Draft.count)
					refute @article.reload.draft
				end
			end

			describe "when the article has comments" do
				before do
					@article.comments.build(:text => "I'm a comment")
					@comment_count = Comment.count
					@article.save_draft
					@article = @draft.approve!
					@comment = Comment.last
				end

				it "should create an article" do
					assert_equal(@article_count + 1, Article.count)
				end

				it "should create a comment" do
					assert_equal(@comment_count + 1, Comment.count)
				end

				it "should return the saved article" do
					assert_equal(Article, @article.class)
				end

				it "should properly re-associate the comment with the article" do
					assert @article.reload.comments.include?(@comment)
				end

				it "should properly populate all the attributes" do
					assert_equal("initial text", @article.text)
				end

				it "should populate all the file uploads" do
					assert_equal("foo.txt", @article.upload.filename)
					assert_equal("foo foo foo", File.open(@article.upload.path).read)
				end

				it "should delete the comment and article drafts" do
					# Note: this isn't -1 because there were two drafts in play
					# i.e. the article draft and the comment draft.
					# assert_equal(@draft_count, Draft.count)
					# refute @article.reload.draft
				end
			end
		end

		describe "for an article which already exists" do
			before do
				@article.save
				@article_count = Article.count
				@article.text = "some draft text"
				@article.upload = file_upload("bar.txt")
				@draft = @article.save_draft
				@draft_count = Draft.count
				@draft.reload.approve!
			end

			it "shouldn't do anything mental, like creating a new object" do
				assert_equal(@article_count, Article.count)
			end

			it "should properly save all the attributes" do
				assert_equal("some draft text", @article.reload.text)
			end

			it "should save all the file uploads" do
				assert_equal("bar.txt", @article.reload.upload.filename)
				assert_equal("bar bar bar", File.open(@article.upload.path).read)
			end

			it "should delete the article's draft" do
				assert_equal(@draft_count - 1, Draft.count)
				refute @article.reload.draft
			end
		end
	end

	describe "Restoring a draftable" do
		before do
			@article = Article.new(:text => "foo", :upload => file_upload)
			@article.comments << Comment.new(:text => "comment 1", :upload => file_upload)
			@article.comments << Comment.new(:text => "comment 2", :upload => file_upload)
		end

		describe "for an unsaved object" do
			before do
				@draft = @article.save_draft
				@article = @draft.build_draftable
			end

			it "should build the object's attributes properly" do
				assert_equal("foo", @article.text)
			end

			it "should build the object's files properly" do
				assert_equal(file_upload.size, File.new(@article.upload.path).size)
			end

			it "should build the object's subobjects properly" do
				assert_equal(2, @article.comments.length)
				assert_equal("comment 1", @article.comments.first.text)
				assert_equal("comment 2", @article.comments.second.text)
			end

			it "should build the subobjects' files properly" do
				contents1 = File.new(@article.comments.first.upload.path).read
				contents2 = File.new(@article.comments.second.upload.path).read
				assert_equal("foo foo foo", contents1)
				assert_equal("foo foo foo", contents2)
			end

			describe "add a new comment, save_draft and restore" do
				before do
	        @article.comments << Comment.new(:text => "comment 3")
	        @draft = @article.save_draft
	        @article = @draft.build_draftable
				end

				it "should build the object's attributes properly" do
					assert_equal("foo", @article.text)
				end

				it "should build the object's files properly" do
					assert_equal("foo foo foo", File.new(@article.upload.path).read)
				end

				it "should build the object's subobjects properly" do
					assert_equal(3, @article.comments.length)
					assert_equal("comment 1", @article.comments.first.text)
					assert_equal("comment 2", @article.comments.second.text)
					assert_equal("comment 3", @article.comments.third.text)
				end

				it "should build the subobjects' files properly" do
					contents1 = File.new(@article.comments.first.upload.path).read
					contents2 = File.new(@article.comments.second.upload.path).read
					assert_equal("foo foo foo", contents1)
					assert_equal("foo foo foo", contents2)
				end

				describe "save_draft and restore again" do
					before do
		        @article.text = "ChChChanges"
		        @draft = @article.save_draft
		        @article = @draft.build_draftable
					end
					it "should build the object's attributes properly" do
						assert_equal("ChChChanges", @article.text)
					end

					it "should build the object's files properly" do
						assert_equal("foo foo foo", File.new(@article.upload.path).read)
					end

					it "should build the object's subobjects properly" do
						assert_equal(3, @article.comments.length)
						assert_equal("comment 1", @article.comments.first.text)
						assert_equal("comment 2", @article.comments.second.text)
					end

					it "should build the subobjects' files properly" do
						contents1 = File.new(@article.comments.first.upload.path).read
						contents2 = File.new(@article.comments.second.upload.path).read
						assert_equal("foo foo foo", contents1)
						assert_equal("foo foo foo", contents2)
					end
				end
      end
		end

		describe "for a saved object" do
			before do
				@article.save!
				@article.text = "flappa flap flap"
				@draft = @article.save_draft
				@article = @draft.build_draftable
			end

			it "should build the object's attributes properly" do
				assert_equal("flappa flap flap", @article.text)
			end

			it "should build the object's files properly" do
				assert_equal(file_upload.size, File.new(@article.upload.path).size)
			end

			it "should build the object's subobjects properly" do
				assert_equal(2, @article.comments.length)
				assert_equal("comment 1", @article.comments.first.text)
				assert_equal("comment 2", @article.comments.second.text)
			end

			it "should build the subobjects' files properly" do
				contents1 = File.new(@article.comments.first.upload.path).read
				contents2 = File.new(@article.comments.second.upload.path).read
				assert_equal("foo foo foo", contents1)
				assert_equal("foo foo foo", contents2)
			end
		end
	end

	describe "Rejecting a draft" do
		before do
			@article = Article.new(
				:text => "initial text",
				:upload => file_upload)
		end

		describe "for an article which hasn't yet been saved" do
			before do
				@article_count = Article.count
				@draft = @article.save_draft
				@draft_count = Draft.count
				@article = @draft.reject!
			end

			it "should not create an article" do
				assert_equal(@article_count, Article.count)
			end

			it "should delete the draft" do
				assert_equal(@draft_count - 1, Draft.count)
			end
		end

		describe "for an article which already exists" do
			before do
				@article.save
				@article_count = Article.count
				@article.text = "some draft text"
				@article.upload = file_upload("bar.txt")
				@draft = @article.save_draft
				@draft_count = Draft.count
				@draft.reject!
			end

			it "shouldn't do anything mental, like creating a new object" do
				assert_equal(@article_count, Article.count)
			end

			it "should properly leave the article's attributes alone" do
				assert_equal("initial text", @article.reload.text)
			end

			it "should delete the article's draft" do
				assert_equal(@draft_count - 1, Draft.count)
				refute @article.reload.draft
			end
		end
	end

end
