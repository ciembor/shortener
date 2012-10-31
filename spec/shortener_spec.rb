require_relative 'spec_helper'

describe "Sinatra App" do
	
	test_site = 'http://www.google.com/search?hl=en&lr=&c2coff=1&rls=GGLG%2CGGLG%3A2005-26%2CGGLG%3Aen&q=http%3A%2F%2Fwww.google.com%2Fsearch%3Fhl%3Den%26lr%3D%26c2coff%3D1%26rls%3DGGLG%252CGGLG%253A2005-26%252CGGLG%253Aen%26q%3Dhttp%253A%252F%252Fwww.google.com%252Fsearch%253Fhl%253Den%2526lr%253D%2526c2coff%253D1%2526rls%253DGGLG%25252CGGLG%25253A2005-26%25252CGGLG%25253Aen%2526q%253Dhttp%25253A%25252F%25252Fwww.google.com%25252Fsearch%25253Fsourceid%25253Dnavclient%252526ie%25253DUTF-8%252526rls%25253DGGLG%25252CGGLG%25253A2005-26%25252CGGLG%25253Aen%252526q%25253Dhttp%2525253A%2525252F%2525252Fwww%2525252Egoogle%2525252Ecom%2525252Fsearch%2525253Fsourceid%2525253Dnavclient%25252526ie%2525253DUTF%2525252D8%25252526rls%2525253DGGLG%2525252CGGLG%2525253A2005%2525252D26%2525252CGGLG%2525253Aen%25252526q%2525253Dhttp%252525253A%252525252F%252525252Fuk2%252525252Emultimap%252525252Ecom%252525252Fmap%252525252Fbrowse%252525252Ecgi%252525253Fclient%252525253Dpublic%2525252526GridE%252525253D%252525252D0%252525252E12640%2525252526GridN%252525253D51%252525252E50860%2525252526lon%252525253D%252525252D0%252525252E12640%2525252526lat%252525253D51%252525252E50860%2525252526search%252525255Fresult%252525253DLondon%25252525252CGreater%252525252520London%2525252526db%252525253Dfreegaz%2525252526cidr%252525255Fclient%252525253Dnone%2525252526lang%252525253D%2525252526place%252525253DLondon%252525252CGreater%252525252BLondon%2525252526pc%252525253D%2525252526advanced%252525253D%2525252526client%252525253Dpublic%2525252526addr2%252525253D%2525252526quicksearch%252525253DLondon%2525252526addr3%252525253D%2525252526scale%252525253D100000%2525252526addr1%252525253D%2526btnG%253DSearch%26btnG%3DSearch&btnG=Search'
	
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
