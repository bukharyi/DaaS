require 'sinatra'
require "sinatra/namespace"
require 'json'

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

post '/record' do
  #recieved domain 
  #recieved namespace
  #"namespace '#{params[:namespace]}', domain '#{params[:domain]}'"
  
  output=recordAdd("#{params[:namespace]}", "#{params[:domain]}" ) 
  
  if output['exitcode']==0
    status 201
    body JSON.pretty_generate(output)
 else
    status 404
    body JSON.pretty_generate(output)
  
 end
   
  
 
end#end POST /record/add/


  delete '/record' do
    #recieved domain 
    
    output=recordDelete("#{params[:domain]}" ) 
    domain="#{params[:domain]}"
    
    if domain.empty?
      status 404
      body "Error, empty request"
      elseif ['exitcode']==0 
      status 201
      body JSON.pretty_generate(output)
    else 
      status 404
      body JSON.pretty_generate(output)
   end
     
    
   
  end#end POST /record/add/



end
