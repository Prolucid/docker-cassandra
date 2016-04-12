FROM phusion/baseimage
MAINTAINER Daniel Covello
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Install Datastax Opscenter
RUN echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.community.list \
	&& curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add - \
	&& apt-get update && apt-get -y install opscenter

# Add service starutp scripts
RUN mkdir -p /etc/service/opscenter
ADD start-opscenter.sh /etc/service/opscenter/run
RUN chmod +x /etc/service/opscenter/run

# Expose Ports
EXPOSE 8888 61620 50031

# Create Volumes
VOLUME ["/var/log/opscenter"]
