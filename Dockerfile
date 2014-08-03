FROM phusion/passenger-nodejs:0.9.11

# UNCOMMENT FOR TESTING - DANGER!
RUN /usr/sbin/enable_insecure_key

# setup rethinkdb client
RUN gem install rethinkdb

# install required node packages
RUN npm install -g path
RUN npm install -g http
RUN npm install -g rethinkdb


# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN rm -f /etc/service/nginx/down

RUN rm -f /etc/nginx/sites-enabled/default
ADD nginx/app.conf /etc/nginx/sites-enabled/app.conf
ADD nginx/servers.conf /etc/nginx/servers.conf
ADD nginx/appid.conf /etc/nginx/appid.conf

ADD node/app.js /home/app/PLACEHOLDERAPP/app.js
RUN chown -R 9999:9999 /home/app/PLACEHOLDERAPP

# Setup startup scripts
RUN mkdir -p /etc/my_init.d
ADD management/start.rb /etc/my_init.d/start.rb
ADD management/updateNodeConf.rb /etc/my_init.d/updateNodeConf.rb
ADD management/startup.sh /home/app/updateNodeConf.rb

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
