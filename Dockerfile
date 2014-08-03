FROM phusion/passenger-nodejs:0.9.11

# UNCOMMENT FOR TESTING - DANGER!
RUN /usr/sbin/enable_insecure_key

RUN gem install --no-ri --no-rdoc rethinkdb

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN rm -f /etc/service/nginx/down

RUN rm -f /etc/nginx/sites-enabled/default
ADD nginx/app.conf /etc/nginx/sites-enabled/app.conf

ADD node/app.js /home/app/appid/app.js
RUN chown -R 9999:9999 /home/app/appid

# Setup startup scripts
RUN mkdir -p /etc/my_init.d
ADD management/start.rb /etc/my_init.d/start.rb

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
