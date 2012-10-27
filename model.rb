require 'data_mapper'

class Address
	include DataMapper::Resource
	
	property :id, Serial
	property :url, String, :required => true, :format => /https?:\/\/[\S]+/, :message => 'URL is not valid!'

	has n, :logs
	
	def short(domain)
		base36 = self.id.to_s(36)
		domain + base36
	end
	
	def stats(domain)
		domain + 'stats/' + self.id.to_s
	end
	
	def self.getByBase36(base36)
		if base36 =~ /[[:alnum:]]+/
			id = base36.to_i(36)
			self.get(id)
		else
			return nil
		end
	end
	
end

class Log
	include DataMapper::Resource
	
	property :id, Serial
	property :browser, String
	
	belongs_to :address
end
