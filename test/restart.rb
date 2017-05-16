def restart
	system("systemctl restart bind9")
	exitCode	=$?
	exitStatus	=$?.exitstatus
	puts exitStatus
end

def validate
	system("named-checkzone localhost /etc/bind/zones/db.focus.my")
	exitStatus = $?.exitstatus
	if exitStatus > 0
		puts "something wrong"
	else
		puts "Validation OK!"
	end
end

validate
restart	

