# Creates an article so we've got a bit of test data.
Article.create!(:text => "foo")
raise "blah" unless Article.count > 0