#!/bin/bash

if [ ! -f /var/jenkins_home/.ssh/id_rsa ]; then
	exec ssh-keygen -N '' -f /var/jenkins_home/.ssh/id_rsa
fi

exec java -jar /usr/local/lib/swarm-slave.jar -master http://$MASTER_HOST:$MASTER_PORT -labels $JENKINS_LABELS -disableSslVerification -username $JENKINS_USERNAME -password $JENKINS_PASSWORD -fsroot $JENKINS_HOME -mode exclusive 
