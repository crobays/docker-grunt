FROM phusion/baseimage:0.9.16
ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

MAINTAINER Crobays <crobays@userex.nl>
ENV DOCKER_NAME grunt
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get dist-upgrade -y

RUN apt-get install -y \
	curl \
	git

ADD /scripts/rvm.sh /scripts/rvm.sh
RUN /scripts/rvm.sh
ENV PATH /usr/local/rvm/bin:$PATH

RUN gem install sass -v 3.4.9
RUN gem install compass
RUN gem uninstall sass -v 3.4.6 2&>/dev/null

ADD /scripts/download-and-install.sh /scripts/download-and-install.sh
ADD /scripts/node.sh /scripts/node.sh
RUN /scripts/node.sh

ENV PATH /usr/local/node/bin:/root/node_modules/.bin:./node_modules/.bin:$PATH

WORKDIR /project

RUN npm install -g grunt
RUN cd /root && npm install \
	grunt-cli \
	jit-grunt \
	grunt-browser-sync

# Exposed ENV
ENV TIMEZONE Etc/UTC
ENV ENVIRONMENT production
ENV BASE_DIR static/app
ENV STYLES_DIR styles
ENV SCRIPTS_DIR scripts
ENV IMAGES_DIR images

VOLUME ["/project"]

# BrowserSync port
EXPOSE 3000 3001

RUN echo '/sbin/my_init' > /root/.bash_history

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /etc/service/grunt
ADD /scripts/grunt-run.sh /etc/service/grunt/run

RUN echo "#!/bin/bash\necho \"\$TIMEZONE\" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata" > /etc/my_init.d/01-timezone.sh
ADD /scripts/grunt-config.sh /etc/my_init.d/02-grunt-config.sh

RUN chmod +x /etc/my_init.d/* && chmod +x /etc/service/*/run

ADD /conf /conf

# docker build \
# --tag crobays/grunt \
# /workspace/docker/crobays/grunt && \
# docker run \
# -v /workspace/projects/mediamoose/crm:/project \
# -p 3000:3000 \
# -p 3001:3001 \
# -e ENVIRONMENT=development \
# -e TIMEZONE=Europe/Amsterdam \
# --name grunt \
# -it --rm \
# crobays/grunt bash


# docker run \
#   -v /workspace/projects/crobays/foundation-apps:/project \
#   -p 3000:3000 \
#   -e ENVIRONMENT=dev \
#   -e TIMEZONE=Europe/Amsterdam \
#   -it --rm \
#   crobays/grunt bash

# /etc/my_init.d/01-timezone.sh ;/etc/my_init.d/02-grunt-config.sh
