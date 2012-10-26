require_relative 'spec_helper'

describe "Sinatra App" do
	
	test_site = 'http://google.pl/'
	
	it "As a user I can shorten the URL by going to URL shortener main page." do
		get '/'
		last_response.should be_ok
		
		for i in 1..12
			post '/', params = {url: test_site} do
				Address.get(i).url.should == test_site
			end
		end

		last_response.should be_ok
	end

	it "As a user who has received a shortened URL I can access (I am redirected to) the original URL." do
		get '/b'
		last_response.should be_redirect 
		follow_redirect!
		last_request.url.should == test_site
	end
	
	it "As the person who shortened a URL I can see usage statistics page." do
		for i in 0..3
			Address.get(12).logs.length.should == i
			get '/c'
			get '/stats/12'
			last_response.should be_ok
		end
	end

end
