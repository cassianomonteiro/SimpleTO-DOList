# RestKit Sinatra Testing Server
# Place file as Server.rb and run with `ruby Server.rb` before executing the test suite within Xcode
# Service will be available at base URL http://localhost:4567

require 'rubygems'
require 'sinatra'
require 'json'

# See http://www.sinatrarb.com/configuration.html for configuring settings
configure do
    set :logging, true
    set :dump_errors, true
    
    # Set puclic folder as the root of Server.rb
    set :public_folder, Proc.new { File.expand_path(root) }
end

before do
    # Disable cache to not mess up tests
    cache_control :no_cache, :max_age => 0
    
    # Mandatory header firebase_key for all requests
    halt 400 unless request.env['HTTP_FIREBASE_KEY']
end

def render_fixture(filename)
    send_file File.join(settings.public_folder, filename)
end

# For routes, see http://www.sinatrarb.com/intro.html

# Route to match user creation
post '/user' do
    halt 400 unless request.content_type =~ /application\/json/i
    
    # Get JSON body contents
    request.body.rewind
    request_payload = JSON.parse request.body.read
    
    halt 400 unless request_payload['firebase_key'] == 'abcde'
    
    render_fixture('UserResponse.json')
end


# Route to match lists request
get '/api/lists' do
    halt 400 unless request.env['HTTP_FIREBASE_KEY']== 'abcde'
    render_fixture('ListsResponse.json')
end
