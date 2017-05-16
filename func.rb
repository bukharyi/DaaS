require 'csv'
require 'json'
require 'sysrandom'
CSVFILE	="nodes.csv"
KEYFILE	="ddns.key"
OUTPUTFILE="input.txt"
PRIMARYNS="192.168.138.3"
ZONE="focus.my"


########################
##remove node from csv
########################
  def nodeRemove

  end
########################
##add node to csv
########################
  def nodeAdd

  end
########################
##return list of nodes in json
########################
def nodeList
	data = CSV.read('nodes.csv')
	jsonData = data.to_json
	puts "myjson data"
	puts jsonData
#	puts JSON.pretty_generate(data)
end
########################
##describe node
########################
def nodeDescribe
	return nodeInfo
end
########################
##Add record
########################
def recordAdd(namespace, subdomain)
#record		= {subdomain, nil=autogen}
#namespace	= {ns, nil=autogen}

# subdomain  empty, generate subdomain
if subdomain.empty?
	subdomain=Sysrandom.hex(10)
end
#if namespace empty? add to main zone
if namespace.empty?
	subdom="#{subdomain}.#{ZONE}"
  else
	 subdom="#{subdomain}.#{namespace}.#{ZONE}"
end

genfileAdd(subdom)
nsupdate

end
########################
##generate file to add
########################
def genfileAdd(subdomain)
  system("echo \"server #{PRIMARYNS}\" 	>  #{OUTPUTFILE}")
  system("echo \"debug yes \" 		>> #{OUTPUTFILE}")
  system("echo \"zone #{ZONE} \" 		>> #{OUTPUTFILE}")

  #for each node IP, add domain
  CSV.foreach(CSVFILE) { |row| 
  	system("echo \"update add #{subdomain} 60000 A #{row[1]} \" 	>> #{OUTPUTFILE}")
  }
  system("echo \"send\"			>> #{OUTPUTFILE}")
end
########################
##generate file to del
########################
def genfileDel(subdomain)
  system("echo \"server #{PRIMARYNS}\"      >  #{OUTPUTFILE}")
  system("echo \"debug yes \"               >> #{OUTPUTFILE}")
  system("echo \"zone #{ZONE} \"            >> #{OUTPUTFILE}")
  system("echo \"update del #{subdomain} \" >> #{OUTPUTFILE}")
  system("echo \"send\"                     >> #{OUTPUTFILE}")
end

########################
##execute dnsupdate
########################
def nsupdate
  system("nsupdate -k #{KEYFILE} -v #{OUTPUTFILE} ")
  
  
end
########################
##Delete record
########################
def recordDelete(subdomain)
if subdomain.empty?
  return -1
else
  genfileDel(subdomain)
  nsupdate
  return 0
end
end

#nsupdate
#nodeList
	#zone, ns, record

#standard req
#recordAdd("kube-system","ayam")
#without ns
#recordAdd("","kambing")
#without subdomain
#recordAdd("kube-system","")

#recordAdd("","")
#recordDelete("ayam.kube-system.focus.my")


