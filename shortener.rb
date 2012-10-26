require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/base'
require 'erb'
require 'uri'
require 'browser'

require './model'

class Shortener < Sinatra::Base

	configure do
		DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/shortener.db")
		DataMapper.finalize
		DataMapper.auto_upgrade!
	end	 

	# main page
	get '/' do
		erb :index
	end

	# page after posting a form
	post '/' do
		@messages = []
		
		if (params[:url] =~ URI::regexp).nil?
			@messages.push('URL is not valid!')
		else
			address = Address.create(:url => params[:url])
			
			base36 = address.id.to_s(36)
			@shorter = request.url + base36
			@stats = request.url + 'stats/' + address.id.to_s
		end
		
		erb :index
	end
	
	# redirection from a short url
	get '/:base36' do |base36| 
		# probably not necessary...
		if base36 =~ /[[:alnum:]]+/
			begin
				id = base36.to_i(36)
				address = Address.get(id)
				
				browser = Browser.new(:ua => request.user_agent).name
				
				log = Log.create(:browser => browser)
				address.logs << log
				address.save
				
				redirect address.url
			rescue
				redirect '/'
			end
		else
			redirect '/'
		end
	end

	# site with statistics
	get '/stats/:id' do |id|
		# probably not necessary...
		if id =~ /[[:digit:]]+/
			begin
				logs = Address.get(id).logs
				@views = logs.length
				@browsers = logs.aggregate(:browser, :all.count)
							
				erb :stats
			rescue
				redirect '/'
			end
		else
			redirect '/'
		end
	end

end
