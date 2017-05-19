require 'csv'
require 'awesome_print'

@csvfile='../data/nodes.csv'

=begin
index=0
col_data = []
CSV.foreach("../data/nodes.csv") {|row| 
  
  if row[1]=="192.168.138.3" then

  end
col_data << row[1]

index=index+1
}#end for each

ap col_data
=end

table = CSV.table(@csvfile)
table.delete_if do |row|
  row[:ip] =='192.168.138.3'
end

File.open(@csvfile,'w') do |f|
  f.write(table.to_csv)
end
