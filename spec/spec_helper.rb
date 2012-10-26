require 'sinatra'
require 'rspec'
require 'rack/test'

require_relative '../shortener'

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
	Shortener
end

RSpec.configure do |config|
	config.include Rack::Test::Methods
	DataMapper.setup(:default, 'sqlite::memory:')
	DataMapper.finalize
	DataMapper.auto_upgrade!
end
