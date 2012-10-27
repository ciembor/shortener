require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/base'
require 'erb'
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
		address = Address.create(:url => params[:url])
		
		if address.save
			@short = address.short(request.url)
			@stats = address.stats(request.url)
		else
			@messages = address.errors
		end
		
		erb :index
	end
	
	# redirection from a short url
	get '/:base36' do |base36| 
		begin
			address = Address.getByBase36(base36)
			browser = Browser.new(:ua => request.user_agent).name

			log = Log.create(:browser => browser)
			address.logs << log
			address.save
			
			redirect address.url
		rescue
			redirect '/'
		end
	end

	# site with statistics
	get '/stats/:id' do |id|
		begin
			logs = Address.get(id).logs
			@views = logs.length
			@browsers = logs.aggregate(:browser, :all.count)
						
			erb :stats
		rescue
			redirect '/'
		end
	end

end
