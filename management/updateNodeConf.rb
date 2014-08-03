#!/usr/bin/env ruby

require 'rubygems'
require 'rethinkdb'
include RethinkDB::Shortcuts
conn = r.connect(:host => ENV['CENTRAL'], :port => 28015, :db => 'management').repl

r.table('nodes').changes().filter{|row| # catches only changes that add/delete nodes
		(row['old_val'].eq(nil))# || row['new_val'].eq(nil))
	}.run(conn).each{|change|
	p(change)

        repo = change["new_val"]["repo"]
	ipToAdd = change["new_val"]["ip"]
	id = change["new_val"]["id"]
	# every change here should lead us to rewrite the nginX config
	# /etc/nginx/sites-enabled/app.conf
	config = ""

        conf = File.open('/etc/nginx/servers.conf').read
	conf.each_line do |li|
		config += li
  		if (li['upstream cluster {'])
  			puts "found beginning of config section: add an ip address here"
  			config += "server #{ipToAdd}:1995;\n"
  		end
	end

        exec "git clone #{repo} /home/app/#{id}"
        exec "git chown 9999:9999 -R /home/app/#{id}"

	# edit config
        File.write('/etc/nginx/servers.conf', config)
	# reload nginx
	exec '/etc/init.d/nginx reload'

}


#
#if (change["new_val"] == nil)
#		config = ""
#
#		conf = File.open('/etc/nginx/sites-enabled/app.conf').read
#		conf.each_line do |li|
#	  		if (!(li["server #{ipToAdd}:1995"]))
#	  			config += li
#	  		else
#	  			puts "found line to remove ip"
#	  		end
#		end

		# edit config
#		File.write('/etc/nginx/sites-enabled/app.conf', config)
#		# reload nginx
#		exec '/etc/init.d/nginx reload'
#	else
