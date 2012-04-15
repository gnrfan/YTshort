require 'rubygems'
require 'bundler'
Bundler.setup

require 'haml'
require 'sinatra'

require 'net/http'
require 'cgi'

set :public_folder, ::File.dirname(__FILE__) + '/public'
set :views, ::File.dirname(__FILE__) + '/templates'
set :haml, {:format => :html5}

get '/' do
  if params.has_key?("url") 
    @original_uri = params["url"]
    uri = URI.parse(@original_uri)
    if uri.host == 'www.youtube.com'
      uri_params = CGI.parse(uri.query)
      if uri_params.has_key?("v")
        @short_url = "http://youtu.be/" + uri_params["v"][0]
      else
        @error = "No video referenced."
      end
    else
      @error = "URL is not from YouTube."
    end
  else
    rickroll_uri = "http://www.youtube.com/watch?v=oHg5SJYRHA0"
    example_uri  = request.scheme + "://" + request.host_with_port
    example_uri += "/?url=" + rickroll_uri
    @error = "No URL passed as GET parameter. E.g. " + example_uri
  end
  haml :index
end
