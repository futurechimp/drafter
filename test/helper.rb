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

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'active_record'
require 'minitest/matchers'
require 'valid_attribute'
require 'drafter'
require 'turn'

# Establish a connection to our test database
ActiveRecord::Base.establish_connection(
	:adapter => "sqlite3",
	:database => File.dirname(__FILE__) + "/drafter.sqlite3")

load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/models.rb'
load File.dirname(__FILE__) + '/support/data.rb'

class MiniTest::Unit::TestCase
  # include MiniTest::Assertions::ActiveRecord
  include ::ValidAttribute::Method
end

MiniTest::Unit.autorun

Turn.config do |c|
 c.format  = :outline
 c.trace   = false
 c.natural = true
end