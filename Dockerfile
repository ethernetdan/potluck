FROM phusion/passenger-nodejs:0.9.11

# UNCOMMENT FOR TESTING - DANGER!
RUN /usr/sbin/enable_insecure_key

# Setup python
RUN curl -O http://mirrors.kernel.org/ubuntu/pool/main/p/python2.7/python2.7_2.7.6-8_amd64.deb
RUN dpkg -i python2.7_2.7.6-8_amd64.deb

# Setup pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

RUN pip install rethinkdb

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN rm -f /etc/service/nginx/down

RUN rm -f /etc/nginx/sites-enabled/default
ADD nginx/app.conf /etc/nginx/sites-enabled/app.conf

ADD node/app.js /home/app/appid/app.js
RUN chown -R 9999:9999 /home/app/appid

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
