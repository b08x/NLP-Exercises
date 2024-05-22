#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../bin', __dir__))

require 'knowlecule'

require 'sinatra'
require 'nokogiri'
require 'open-uri'

set :logging, true
set :bind, '0.0.0.0'

# Define a route for handling GET requests
get '/' do
  content_type :json
  { item: 'Red Dead Redemption 2', price: 19.79, status: 'Available' }.to_json
end

# Define a route for handling POST requests with text data
post '/tag' do
  content_type :json
  # Parse the incoming JSON data
  data = JSON.parse(request)

  
end

# Define a route for handling POST requests with text data
get '/some' do
  content_type :json
  # Parse the incoming JSON data
  data = JSON.parse(request.body.read)

  p data
end
