require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/spec'
require 'debugger'
require 'database_cleaner'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'active_record'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'drafter'
require 'turn'
require 'minitest/matchers'
require "shoulda/matchers/active_record"
require "shoulda/matchers/active_model"

# Establish a connection to our test database
ActiveRecord::Base.establish_connection(
	:adapter => "sqlite3",
	:database => File.dirname(__FILE__) + "/drafter.sqlite3")

load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/uploader.rb'
load File.dirname(__FILE__) + '/support/models.rb'
load File.dirname(__FILE__) + '/support/data.rb'

DatabaseCleaner.strategy = :transaction

class MiniTest::Spec

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  # Pull in shoulda matchers for minitest.
  #
  # You need to have the minitest-matchers gem and the minitest-rails-shoulda gem
  # for this to work.
  include Shoulda::Matchers::ActiveRecord
  extend Shoulda::Matchers::ActiveRecord
  include Shoulda::Matchers::ActiveModel
  extend Shoulda::Matchers::ActiveModel

  def file_upload(name="foo.txt")
  	File.new(File.dirname(__FILE__) + "/fixtures/#{name}")
  end

end

MiniTest::Unit.autorun