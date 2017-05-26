require 'csv'
namespace="kube-system"
domain="bukhary.focus.my"
date="2017-05-15 16:51:23"

CSV.open("../data/domain.csv", "a") do |csv|
  csv << [namespace, domain, date]
end