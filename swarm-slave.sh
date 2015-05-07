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


ARGUMENT="-jar /usr/local/lib/swarm-slave.jar -fsroot /var/jenkins_slave_home -disableSslVerification"

if [ $JENKINS_MASTER_HOST != "*** Auto Discovery ***" ]; then
  ARGUMENT="$ARGUMENT -master http://$JENKINS_MASTER_HOST:$JENKINS_MASTER_PORT"
fi

if [ $JENKINS_MASTER_USERNAME != "*** Optional ***" ]; then
  ARGUMENT="$ARGUMENT -username $JENKINS_MASTER_USERNAME"
fi

if [ $JENKINS_MASTER_PASSWORD != "*** Optional ***" ]; then
  ARGUMENT="$ARGUMENT -password $JENKINS_MASTER_PASSWORD"
fi


if [ $JENKINS_SLAVE_NAME != "*** Optional ***" ]; then
  ARGUMENT="$ARGUMENT -name $JENKINS_SLAVE_NAME"
fi

if [ $JENKINS_SLAVE_LABELS != "*** Optional ***" ]; then
  ARGUMENT="$ARGUMENT -mode exclusive -labels $JENKINS_SLAVE_LABELS"
fi


echo java $ARGUMENT
exec java $ARGUMENT
