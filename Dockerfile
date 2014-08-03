FROM phusion/passenger-nodejs:0.9.11

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN rm -f /etc/service/nginx/down
ADD loadbalancer.conf /etc/nginx/sites-enabled/loadbalancer.conf

ADD app.js /home/app/appid/app.js

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
