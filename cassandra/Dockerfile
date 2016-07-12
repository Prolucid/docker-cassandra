FROM phusion/baseimage 
MAINTAINER Daniel Covello 
ENV DEBIAN_FRONTEND noninteractive

ENV CASSANDRA_VERSION 3.5

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update

# Install other packages
RUN apt-get install -y curl

# Preemptively accept the Oracle License
RUN echo "oracle-java8-installer	shared/accepted-oracle-license-v1-1	boolean	true" > /tmp/oracle-license-debconf
RUN /usr/bin/debconf-set-selections /tmp/oracle-license-debconf
RUN rm /tmp/oracle-license-debconf

# Install the JDK
RUN apt-get install -y oracle-java8-installer oracle-java8-set-default
RUN apt-get update

RUN echo "deb http://debian.datastax.com/datastax-ddc $CASSANDRA_VERSION main" | tee -a etc/apt/sources.list.d/cassandra.sources.list
RUN curl -L https://debian.datastax.com/debian/repo_key | apt-key add -
RUN apt-get update && apt-get -y install datastax-ddc

# Copy Cassandra Startup Scripts
RUN mkdir /etc/service/cassandra
ADD src/start-cass.sh /etc/service/cassandra/run
RUN chmod +x /etc/service/cassandra/run

# Copy Cassandra Startup Scripts
RUN mkdir /etc/service/datastax_agent
ADD src/start-agent.sh /etc/service/datastax_agent/run
RUN chmod +x /etc/service/datastax_agent/run

# Expose Ports
EXPOSE 7199 7000 7001 9160 9042

# Add Volumes
VOLUME ["/var/lib/cassandra"]
