FROM phusion/baseimage:0.9.19 
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

# Add cassandre repo
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 514A2AD631A57A16DD0047EC749D6EEC0353B12C && \
    echo 'deb http://www.apache.org/dist/cassandra/debian 35x main' >> /etc/apt/sources.list.d/cassandra.list


# Install the JDK
RUN apt-get install -y oracle-java8-installer oracle-java8-set-default

# Install cassandra + dependencies
RUN apt-get update -y && apt-get install -y software-properties-common \
    && apt-get install wget \
    && apt-get install -yq --force-yes --no-install-recommends \
                python-dev python-pip python-setuptools \ 
                libffi-dev libssh2-1-dev zlib1g-dev libssl-dev \
                pkg-config libhttp-parser-dev virt-what python-m2crypto \
                gcc \
    && wget http://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb \
    && dpkg -i python-support_1.0.15_all.deb \
    && apt-get install -y cassandra="$CASSANDRA_VERSION" \
    && rm -rf /var/lib/apt/lists/*

##Instal missing python-support
#RUN apt-get update && apt-get install ajenti \
#    && wget http://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb \
#    && dpkg -i python-support_1.0.15_all.deb

#RUN echo "deb http://debian.datastax.com/datastax-ddc $CASSANDRA_VERSION main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list
#RUN cat /etc/apt/sources.list.d/cassandra.sources.list
#RUN curl -L https://debian.datastax.com/debian/repo_key | apt-key add -
#RUN apt-get update && apt-get -y install ajenti datastax-ddc

# Copy Cassandra Startup Scripts
RUN mkdir /etc/service/cassandra
ADD src/start-cass.sh /etc/service/cassandra/run
RUN chmod +x /etc/service/cassandra/run

# Expose Ports
EXPOSE 7199 7000 7001 9160 9042

# Add Volumes
VOLUME ["/var/lib/cassandra"]
