################################
#    Potluck Dockerfile        #
# made with love at YC Hacks   #
#         by Dan               #
################################

# set application server base image
FROM phusion/passenger-nodejs:0.9.11

# Warning: Uncommenting this line will allow anyone to SSH into your container
# RUN /usr/sbin/enable_insecure_key

#= Ruby dependencies
RUN gem install rethinkdb

#= Node dependencies
RUN npm install -g path
RUN npm install -g http
RUN npm install -g rethinkdb

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Enable nginx
RUN rm -f /etc/service/nginx/down

# Disable default nginx site
RUN rm -f /etc/nginx/sites-enabled/default

# Configure nginx
ADD nginx/app.conf /etc/nginx/sites-enabled/app.conf
ADD nginx/servers.conf /etc/nginx/servers.conf
ADD nginx/appid.conf /etc/nginx/appid.conf

# Setup startup scripts
RUN mkdir -p /etc/my_init.d
ADD management/start.rb /etc/my_init.d/start.rb
ADD management/updateNodeConf.rb /home/app/updateNodeConf.rb
ADD management/astartup.sh /etc/my_init.d/astartup.sh

# Clean up after installation
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
