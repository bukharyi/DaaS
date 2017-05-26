require 'sqlite3'
require 'awesome_print'

begin
    
    db = SQLite3::Database.new "../data/daas.db"
    
    namespace="kube-system"
    
    stm = db.prepare "SELECT domain,namespace FROM domain where namespace=?"
    stm.bind_param 1, namespace
    rs = stm.execute

rs.each do |row|
  puts row.join "\s"
end
    
rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    ap e
    
ensure
    stm.close if stm
    db.close if db
end