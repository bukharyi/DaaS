#!/root/.rbenv/shims/ruby
require 'rubygems'
require 'net/dns'

def resolve(query)
	p Resolver("#{query}")
#	packet = Net::DNS::Resolver.start("#{query}")
#	header = packet.header
#	answer = packet.answer
#	answer.any? {|ans| p ans}

end


resolve("kambing.focus.my")
