require 'json'
require 'awesome_print'
require 'sysrandom'
require 'sqlite3'
DBLOCATION      = "./data/daas.db"
#CSVNODEFILE	    = "./data/nodes.csv" # list of nodes
#CSVDOMAINFILE   = "./data/domain.csv" # list of domain
KEYFILE	        = "./data/ddns.key"
OUTPUTFILE      = "./data/input.txt"
PRIMARYNS       = "192.168.138.3"
ZONE            = "focus.my"


########################
##List domain
########################
#receive 
#domain = {domain, nil=autogen}
#namespace = {ns, nil}
def domainList(namespace)

  if namespace.empty?
    return -1, {'message'=>"ERROR namespace empty",'display'=> ""}
  end
  
  paramArr  = [namespace]
  statement = "SELECT * FROM domain WHERE  namespace=?"  
  errorcode, output=sqlExecute(statement,paramArr)
  
  return errorcode,output   
    
end

########################
##Add domain
########################
#receive 
#domain = {domain, nil=autogen}
#namespace = {ns, nil}
def domainAdd(namespace, domain)
  #validation if namespace empty?
   if namespace.empty?
     output={'message'=>'ERROR empty namespace', 'display'=>''}
       return -1, output
   end
  
    # domain  empty, generate domain
    if domain.empty?
    	domain=Sysrandom.hex(10)
    	fqdn="#{domain}.#{ZONE}"
    else
      fqdn=domain
    end
   
    genfileAdd(fqdn)    
    errorcode,output=nsupdate
    
    if errorcode!=0
      return errorcode,output
    end

    #if successful add to db.
    paramArr  = [fqdn,namespace,"#{DateTime.now}"]
    statement = "INSERT INTO domain ( domain, namespace, date ) VALUES ( ?,?,? )"
    
    errorcode2, output2=sqlExecute(statement,paramArr)
    
    if errorcode2!=0
      return errorcode2,output2
    end

    return 0, output

end


########################
## Delete domain
########################

def domainDelete(fqdn)
  
  if fqdn.empty?
    errorcode=-1
    output = {  'message' => "ERROR. Domain empty",
                'display' => ""
             }
  else
    #generatefile to delete
    genfileDel(fqdn)  
    errorcode,output=nsupdate
    
  end 
  if errorcode==0
    #delete from db
     paramArr  = [fqdn]
     statement = "DELETE FROM domain WHERE domain=? "
              
     errorcode2, output2=sqlExecute(statement,paramArr)
     ap output2         
     if errorcode2!=0
        return errorcode2,output2
     end
      
  end
  
return errorcode, output

end

########################
## test domain
########################

def domainTest(domain, nameserver)
  
  if nameserver.empty?
    nameserver=PRIMARYNS
  end
  
  if domain.empty? 
        errorcode  =-1 
        message ="ERROR domain empty"
    
  else
      output=`nslookup  #{domain} #{nameserver} 2>&1`
      output.gsub! /\t/,' '
      output=output.split("\n")
      if $?.success?
        errorcode  = 0
        message = "nslookup successful"
        display = output
      else
        errorcode = -1
        
        message = "ERROR unable to resolve"
        display = output
      end
              
  end
  
  return errorcode, {
    'message' => message,
    'display' => display
  }
        
end # end domainDelete


def sqlExecute(statement,paramArr) 

  errorcode=0 #
  db = SQLite3::Database.new DBLOCATION  
  stm = db.prepare statement
  
  if paramArr.count!=0
    index=1
    paramArr.each{ |item| 
      stm.bind_param index, item
      index+=1 
    }#end paramArr
  end
  
  rs = stm.execute #execute command
  display=[]
  rs.each do |row| 
    row=row.to_s
    row=row.gsub('[','')
    row=row.gsub(']','')
    row=row.gsub('"','')

    ap row
    display.push(row.to_s) end
  
  message ='successfully execute SQL statement'
  
  rescue SQLite3::Exception => e  
    message = "ERROR Exception occurred = #{e}"
    display = ''
    
    errorcode=-1   
  ensure
    stm.close if stm
    db.close if db
    
  return errorcode, {'message'=> message,
                    'display' => display}
                      
end #end sqlExecute
########################
##generate file to add
########################

def genfileAdd(domain)
  
  i = 0
  
  system("echo \"server #{PRIMARYNS}\"  >  #{OUTPUTFILE}")
  #system("echo \"debug yes \"    >> #{OUTPUTFILE}")
  system("echo \"zone #{ZONE} \"    >> #{OUTPUTFILE}")

  #for each node IP, add domain
  
  
  statement = "SELECT ip FROM nodes"  
  paramArr  = []
  errorcode, output=sqlExecute(statement,paramArr)

  output['display'].each { |row|         
      system("echo \"update add #{domain} 60000 A #{row} \"  >> #{OUTPUTFILE}")
  }
  
  system("echo \"show \"                    >> #{OUTPUTFILE}")
  system("echo \"send\"                     >> #{OUTPUTFILE}")
end
########################
##generate file to del
########################
def genfileDel(domain)
  system("echo \"server #{PRIMARYNS}\"      >  #{OUTPUTFILE}")
  system("echo \"zone #{ZONE} \"            >> #{OUTPUTFILE}")
  system("echo \"update del #{domain} \" >> #{OUTPUTFILE}")
  system("echo \"show\"                     >> #{OUTPUTFILE}")
  system("echo \"send\"                     >> #{OUTPUTFILE}")
end

########################
##execute dnsupdate
########################

def nsupdate
  output=`nsupdate -k #{KEYFILE} -v #{OUTPUTFILE} 2>&1 `
       output.gsub! /\t/,' '
       output=output.split("\n")
       
       if $?.success?
         errorcode  = 0
         message = "nsupdate successful"
         display = output
       else
         errorcode = -1
         message = "ERROR nsupdate failed"
         display = output
       end  
  
  return errorcode, {
      'message' => message,
      'display' => display
    }
end

#normal request
#ap domainTest("kambing.kube-system.focus.my",'192.168.138.3')
#empty fqdn request=ERROR
#ap domainTest("",'192.168.138.3')
#empty ns request=ERROR
#ap domainTest("kambing.kube-system.focus.my",'')
#wrong ns request=ERROR
#ap domainTest("kambing.com.my",'192.168.138.3-')


#both empty=ERROR
#ap domainAdd("","")
#without domain=autogen
#ap domainAdd("mint","")
#without namespace=ERROR
#ap domainAdd("","facebook.focus.my")
#normal case
#ap domainAdd("kube-system","2.kube-system.focus.my")


#empty request=ERROR
#ap domainDelete("")
#good request!
#ap domainDelete("kambing.kube-system.focus.my")
#ap domainAdd("kube-system","kambing.kube-system.focus.my")

#domainList("kube-system")
#ap domainList("")
ap genfileAdd("7.focus.mmy")

