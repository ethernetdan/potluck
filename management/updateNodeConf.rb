#!/usr/bin/env ruby

require 'rubygems'
require 'rethinkdb'
include RethinkDB::Shortcuts

conn = r.connect(:host => 'localhost', :port => 28015, :db => 'management').repl

r.table('nodes').changes().filter{|row| # catches only changes that add/delete nodes
		(row['old_val'].eq(nil))# || row['new_val'].eq(nil))
	}.run(conn).each{|change|
	p(change)

	ipToAdd = change["new_val"]["ip"]
	id = change["new_val"]["id"]
	# every change here should lead us to rewrite the nginX config
	# /etc/nginx/sites-enabled/app.conf
	config = ""

	conf = File.open('/etc/nginx/sites-enabled/app.conf').read
	conf.each_line do |li|
		config += li
  		if (li['upstream cluster {'])
  			puts "found beginning of config section: add an ip address here"
  			config += "server #{ipToAdd}:1995;\n"
  		end
	end

	# edit config
	File.write('/etc/nginx/sites-enabled/app.conf', config)
	# reload nginx
	exec '/etc/init.d/nginx reload'

	# if NEW:
	exec "echo #{ipToAdd}"
	exec "git clone <repo> #{id}"
	exec "git pull <repo> #{id}"
	exec "chown 9999:9999 -R /home/app/#{id}"

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
