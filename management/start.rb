require 'rethinkdb'
require 'open-uri'
include RethinkDB::Shortcuts

##################
#     Start      #
##################

# get public ip
publicip = open('http://whatismyip.akamai.com').read


# connect to cluster
con = r.connect(:host => '23.236.55.43')

# setup management db
mgmt = nil
r.db_list.run(con).each{|x|
  if x == 'management'
    mgmt = r.db('management')
  end
}
if mgmt.nil?
  r.db_create('management').run(con)
  mgmt = r.db('management')
end

# setup nodes table
nodes = nil
mgmt.table_list().run(con).each {|x|
  if x == 'nodes'
    nodes = mgmt.table('nodes')
  end
}
if nodes.nil?
  mgmt.table_create('nodes').run(con)
  nodes = mgmt.table('nodes')
end

# add node to db
nodes.filter({:ip => publicip}).delete().run(con)
mgmt.table('nodes').insert({
  :ip => publicip,
  :repo => ENV['repo']
}).run(con)
