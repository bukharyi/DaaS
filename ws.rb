require 'sinatra'
require "sinatra/namespace"
require 'json'
require_relative './func.rb'

set :bind, '0.0.0.0'
namespace '/api/v1' do
  #before do
  #  content_type 'application/json'
  #end
  

  
#############
# ADD Domain
#############
  #recieved 
    #   1. domain 
    #   2. namespace
    #"namespace '#{params[:namespace]}', domain '#{params[:domain]}'"
           
post '/domain' do
  
  errorcode,output=domainAdd("#{params[:namespace]}", "#{params[:domain]}" ) 
  
  if errorcode==0
    status 201
    body JSON.pretty_generate(output)
 else
    status 404 #problem
    body JSON.pretty_generate(output)
  
 end
   
 
end#end POST /domain/add/

#############
# DELETE Domain
#############
#receive
#1. domain 

delete '/domain/:domain' do
    
  domain="#{params[:domain]}"
  
  #verify the domain is available.
  errorcode,output=domainTest(domain,"")
  
  #if available, proceed delete.
  if errorcode==0
    #proceed to delete
    
    errorcode,output=domainDelete(domain) 

    if errorcode==0 
         wscode = 200
            
    else #problem
          wscode = 500   
           output = {
             'message' => "fail to delete domain",
             'display' => output ['display']
           }
    end    
        
 #domain not found in record 
  else
    wscode=404 
    output = {
        'message' => "domain not found in NS",
        'display' => output ['display']
    }
  end
  
  status "#{wscode}"
  body  output.to_json

end#end DELETE /domain/<domain.abc.my>




#############
# Test Domain
#############
#receive
#1. nameserver
#2. domain 
#e.g. /domain/mimos.my/192.168.138.3
get '/domain/:nameserver/:domain' do
  
  domain="#{params['domain']}"
  nameserver="#{params['nameserver']}"
  
  #execute the test
  errorcode,output=domainTest(domain, nameserver)
      
  #ifnothing wrong
  if errorcode==0 
     wscode = 200
        
  else #problem
      wscode = 404   
  end    
  
  status "#{wscode}"
  body  output.to_json
end 



#############
# List Domain
#############
#receive
#1. namespace

#e.g. /domain/mimos.my/192.168.138.3
get '/domainlist/:namespace' do
  
  namespace="#{params['namespace']}"
  
  #execute the test
  errorcode,output=domainList(namespace)
      
  #ifnothing wrong
  if errorcode==0 
     wscode = 200
        
  else #problem
      wscode = 404   
  end    
  
  status "#{wscode}"
  body  output.to_json
end 



end #end all
