FROM phusion/passenger-full:0.9.11

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN rm -f /etc/service/nginx/down
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
