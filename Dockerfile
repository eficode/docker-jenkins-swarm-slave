FROM ubuntu

USER root

RUN apt-get update
RUN apt-get install -y wget git curl zip

# Install Oracle's Java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN update-alternatives --set java /usr/lib/jvm/java-8-oracle/jre/bin/java

# Install Robot Framework with Selenium
RUN apt-get install -y python-pip
RUN pip install robotframework
RUN pip install robotframework-selenium2library

# Install PhantomJS
RUN apt-get install -y phantomjs

# Install JMeter
RUN apt-get install -y jmeter

# Install Multi Mechanize
RUN apt-get install -y python-matplotlib
RUN pip install multi-mechanize

# Install Graphviz
RUN apt-get install -y graphviz

# Install NodeJS and npm
RUN apt-get install -y nodejs npm nodejs-legacy

# Clean Up apt
RUN apt-get clean

# CREATE Jenkins User
RUN useradd -d "/var/jenkins_slave_home" -u 1000 -m -s /bin/bash jenkins
VOLUME /var/jenkins_slave_home

# Add swarm jar
ADD http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.24/swarm-client-1.24-jar-with-dependencies.jar /usr/local/lib/swarm-slave.jar
RUN chmod ugo+rx /usr/local/lib/swarm-slave.jar

# Add startup script
ADD swarm-slave.sh /usr/local/bin/swarm-slave.sh
RUN chmod ugo+rx /usr/local/bin/swarm-slave.sh

# Set Environment for connection
USER jenkins
ENV LANG C.UTF-8
ENV JENKINS_MASTER_HOST *** Auto Discovery ***
ENV JENKINS_MASTER_PORT 80
ENV JENKINS_MASTER_USERNAME *** Optional ***
ENV JENKINS_MASTER_PASSWORD *** Optional ***
ENV JENKINS_SLAVE_LABELS slave robotframework pybot selenium2library phantomjs multi-mechanize graphviz jmeter nodejs linux ubuntu
ENV JENKINS_SLAVE_EXECUTORS 4
ENV JENKINS_SLAVE_NAME *** Optional ***

WORKDIR /var/jenkins_slave_home


# Start Slave
ENTRYPOINT exec /usr/local/bin/swarm-slave.sh
