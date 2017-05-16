require 'sinatra'
require "sinatra/namespace"
require_relative './func.rb'

set :bind, '0.0.0.0'

namespace '/api/v1' do
#       before do
#               content_type 'application/json'
#       end

	##list node
	get '/lb/node/list' do
		'192.168.138.3'
	end

	##add node
	post '/lb/node/add' do
	
		'add node'
	end
	
	##delete node
	get '/lb/node/' do
	end

post '/record/add' do
  #recieved domain 
  #recieved namespace
  "namespace '#{params[:namespace]}', domain '#{params[:domain]}'"
  
  recordAdd("#{params[:namespace]}", "#{params[:domain]}" ) 
  status 201
  body "successful add"
  
 
end

end
