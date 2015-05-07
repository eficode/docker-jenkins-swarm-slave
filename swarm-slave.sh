#!/bin/bash

if [ ! -f /var/jenkins_home/.ssh/id_rsa ]; then
	echo 'Generating new RSA key'
	ssh-keygen -N '' -f /var/jenkins_slave_home/.ssh/id_rsa
fi

echo 'Starting Up swarm slave'
echo 'Connect to ' $MASTER_HOST ':' $MASTER_PORT ' with name ' $SLAVE_NAME
echo ' - Jenkins Master Host:    ' $JENKINS_MASTER_HOST
echo ' - Jenkins Master Port:    ' $JENKINS_MASTER_PORT
echo ' - Jenkins Master Username:' $JENKINS_MASTER_USERNAME
echo ' - Jenkins Master Password:' $JENKINS_MASTER_PASSWORD
echo ' - Jenkins Slave Name:     ' $JENKINS_SLAVE_NAME
echo ' - Jenkins Slave Labels:   ' $JENKINS_SLAVE_LABELS
echo ' - Jenkins Slave Executors:' $JENKINS_SLAVE_EXECUTORS

set ARGUMENT= -name $SLAVE_NAME -master http://$JENKINS_MASTER_HOST:$JENKINS_MASTER_PORT -labels $JENKINS_SLAVE_LABELS -disableSslVerification -username $JENKINS_MASTER_USERNAME -password $JENKINS_MASTER_PASSWORD -fsroot /var/jenkins_slave_home -mode exclusive
echo $ARGUMENT

exec java -jar /usr/local/lib/swarm-slave.jar $ARGUMENT
