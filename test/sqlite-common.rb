require 'sqlite3'
require 'awesome_print'
require 'pp'

DBLOCATION="../data/daas.db"
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
  output=[]
  rs.each do |row| output.push(row) end
  
  
  rescue SQLite3::Exception => e  
    output="Exception occurred"
    errorcode=-1   
  ensure
    stm.close if stm
    db.close if db
 
    
  return errorcode, output  
end #end sqlExecute



paramArr = ["kube-system"]
statement = "SELECT domain,namespace FROM domain WHERE namespace=? "


#paramArr  = ["bukh8","kube-system","#{Date.today}"]
#statement = "INSERT INTO domain ( domain, namespace, date ) VALUES ( ?,?,? )"

errorcode, output=sqlExecute(statement,paramArr)

puts "ERROR CODE = #{errorcode}"
ap output

