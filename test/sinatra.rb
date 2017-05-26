require 'sinatra'
require 'sinatra/namespace'

require 'json'
require 'awesome_print'

set :bind, '0.0.0.0'
namespace '/api/v1' do
  before do
      content_type 'application/json'
    end

  
get '/hello' do
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params['name'] is 'foo' or 'bar'
  body "#{params[:name]}"
end
end #end API/v1
