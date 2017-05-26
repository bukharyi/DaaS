require 'sqlite3'

begin
    
    db = SQLite3::Database.open "domain.db"
    db.execute "CREATE TABLE IF NOT EXISTS domain(domain TEXT PRIMARY KEY, 
        namespace TEXT, date DATE)"
    
rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    puts e
    
ensure
    db.close if db
end
