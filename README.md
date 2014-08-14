Potluck: The Communal Application Server
========================================

Built at YC Hacks 2014

Potluck is a distributed hosting platform which is intended to allow applications to scale at the low fixed monthly cost of a micro VPS instance. In order to deploy developers would run a docker image of the Potluck server on a VPS provider such as Amazon EC2 or Google Compute Engine. Developers specify 2 parameters at this time: the git repository the application is hosted in (currently Node only but Ruby support is in the pipes) and an IP of a node in a Potluck cluster. The initial node should be deployed with its own IP.

After the initial server connects, the clustered servers begin replicating the provided application code and database. The initial node load balances it's requests across the cluster (including to itself). Currently each application is running in the same OS environment but in the future containers will ensure encapsulation of application execution. Data storage is handled currently with a master database running on a central node however this will become actually distributed in the near future.

Language bindings have been written in JavaScript to provide easy access to data regardless of architecture within an application. These bindings do not provide any sort of namespacing or any security whatsoever.

What's Inside it Now? (this could change fast)
+ Docker
+ NodeJS
+ nginx
+ Passenger
+ rethinkDB

Up ahead is smarter load balancing, actually distributed databases, more secure execution, and more! Besides a few simple tests the scaling functionality has not been tested. Hoping to test that out in the near future.


Note: This is completely a work in progress and only the truly unwise would use it for anything worthwhile.

(more to come here)

![Potluck Diagram](http://i.imgur.com/tkV90ZW.png)
