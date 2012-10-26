require 'data_mapper'

class Address
	include DataMapper::Resource
	
	property :id, Serial
	property :url, String, :required => true

	has n, :logs
end

class Log
	include DataMapper::Resource
	
	property :id, Serial
	property :browser, String
	
	belongs_to :address
end
