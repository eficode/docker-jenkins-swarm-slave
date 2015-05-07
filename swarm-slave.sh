#!/bin/bash

if [ ! -f /var/jenkins_home/.ssh/id_rsa ]; then
	echo 'Generating new RSA key'
	ssh-keygen -N '' -f /var/jenkins_slave_home/.ssh/id_rsa
fi

echo 'Connect with confiuration:'
echo ' - Jenkins Master Host:    ' $JENKINS_MASTER_HOST
echo ' - Jenkins Master Port:    ' $JENKINS_MASTER_PORT
echo ' - Jenkins Master Username:' $JENKINS_MASTER_USERNAME
echo ' - Jenkins Master Password:' $JENKINS_MASTER_PASSWORD
echo ' - Jenkins Slave Name:     ' $JENKINS_SLAVE_NAME
echo ' - Jenkins Slave Labels:   ' $JENKINS_SLAVE_LABELS
echo ' - Jenkins Slave Executors:' $JENKINS_SLAVE_EXECUTORS

ARGUMENT="-jar /usr/local/lib/swarm-slave.jar -fsroot /var/jenkins_slave_home -disableSslVerification -executors $JENKINS_SLAVE_EXECUTORS"

if [ "$JENKINS_MASTER_HOST" != "*** Auto Discovery ***" ]; then
  ARGUMENT="$ARGUMENT -master http://$JENKINS_MASTER_HOST:$JENKINS_MASTER_PORT"
fi

if [ "$JENKINS_MASTER_USERNAME" != "*** Optional ***" ]; then
  ARGUMENT="$ARGUMENT -username $JENKINS_MASTER_USERNAME"
fi

if [ "$JENKINS_MASTER_PASSWORD" != "*** Optional ***" ]; then
  ARGUMENT="$ARGUMENT -password $JENKINS_MASTER_PASSWORD"
fi

if [ "$JENKINS_SLAVE_NAME" != "*** Optional ***" ]; then
  ARGUMENT="$ARGUMENT -name $JENKINS_SLAVE_NAME"
fi

if [ "$JENKINS_SLAVE_LABELS" != "*** Optional ***" ]; then
	ARGUMENT="$ARGUMENT -mode exclusive"

	LABELS=($JENKINS_SLAVE_LABELS)
	for LABEL in "${LABELS[@]}"
	do
		 ARGUMENT="$ARGUMENT -labels $LABEL"
	done
fi

echo Executing java $ARGUMENT
exec java $ARGUMENT
