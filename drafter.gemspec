# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "drafter"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["futurechimp"]
  s.date = "2012-08-17"
  s.description = "A"
  s.email = "dave.hrycyszyn@headlondon.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "drafter.gemspec",
    "lib/drafter.rb",
    "lib/drafter/creation.rb",
    "lib/drafter/draft.rb",
    "lib/drafter/draft_upload.rb",
    "lib/drafter/draft_uploader.rb",
    "lib/drafter/draftable.rb",
    "test/drafter/test_creation.rb",
    "test/drafter/test_draft.rb",
    "test/drafter/test_draft_upload.rb",
    "test/drafter/test_draftable.rb",
    "test/fixtures/bar.txt",
    "test/fixtures/foo.txt",
    "test/helper.rb",
    "test/support/data.rb",
    "test/support/models.rb",
    "test/support/schema.rb",
    "test/support/uploader.rb",
    "test/test_drafter.rb",
    "test/watchr.rb"
  ]
  s.homepage = "http://github.com/futurechimp/drafter"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.17"
  s.summary = "Simple"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<sqlite3>, [">= 0"])
      s.add_runtime_dependency(%q<debugger>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<turn>, [">= 0"])
      s.add_development_dependency(%q<carrierwave>, [">= 0"])
      s.add_development_dependency(%q<minitest-rails-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<debugger>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<turn>, [">= 0"])
      s.add_dependency(%q<carrierwave>, [">= 0"])
      s.add_dependency(%q<minitest-rails-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<debugger>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<turn>, [">= 0"])
    s.add_dependency(%q<carrierwave>, [">= 0"])
    s.add_dependency(%q<minitest-rails-shoulda>, [">= 0"])
  end
end
