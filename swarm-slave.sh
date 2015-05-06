#!/bin/bash

if [ ! -f /var/jenkins_home/.ssh/id_rsa ]; then
	echo 'generating new rsa key'
	ssh-keygen -N '' -f /var/jenkins_home/.ssh/id_rsa
fi

echo 'starting up swarm slave'
echo 'Connect to ' $MASTER_HOST ':' $MASTER_PORT ' with name ' $SLAVE_NAME
exec java -jar /usr/local/lib/swarm-slave.jar -name $SLAVE_NAME -master http://$MASTER_HOST:$MASTER_PORT -labels $JENKINS_LABELS -disableSslVerification -username $JENKINS_USERNAME -password $JENKINS_PASSWORD -fsroot $JENKINS_HOME -mode exclusive
