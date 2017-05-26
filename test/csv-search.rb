require 'csv'
require 'awesome_print'

@csvfile='../data/domain.csv'

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

table = CSV.table(@csvfile)
table.delete_if do |row|
  row[:ip] =='192.168.138.3'
end

File.open(@csvfile,'w') do |f|
  f.write(table.to_csv)
end
=end


csv_text = File.read(@csvfile)
csv = CSV.parse(csv_text, :headers => true)
match_data = csv.find_all {|row| row['namespace'] == 'kube-system'}
domainList=[]
match_data.each { |a| domainList.push(a['domain'])}

ap domainList


=begin
csv_table = CSV.table(@csvfile, converters: :all)

row_with_specified_name = csv_table.find  do |row|
    row.field(:namespace) == 'kube-system'
end

p row_with_specified_name.to_csv.chomp #=> "Bahamas,3,21,IT"
=end
