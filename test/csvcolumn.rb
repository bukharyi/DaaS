require 'csv'
FILENAME="nodes.csv"
COL_INDEX=1

col_data = []
CSV.foreach(FILENAME) {|row| col_data << row[COL_INDEX]}

puts col_data
