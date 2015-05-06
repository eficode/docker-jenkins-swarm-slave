#!/bin/bash

if [ ! -f /var/jenkins_home/.ssh/id_rsa ]; then
	exec ssh-keygen -N '' -f /var/jenkins_home/.ssh/id_rsa
fi

if [ ! -f ~/slave.jar ]; then
	if [ -n "$JENKINS_SECRET" ]; then
		exec wget -O ~/slave.jar https://$MASTER_HOST:$MASTER_PORT/jnlpJars/slave.jar --no-check-certificate
	else
		exec wget -O ~/slave.jar http://$MASTER_HOST:$MASTER_PORT/jnlpJars/slave.jar
	fi
fi

if [ -n "$JENKINS_SECRET" ]; then
	exec java -jar ~/slave.jar -jnlpUrl https://$MASTER_HOST:$MASTER_PORT/computer/$SLAVE_NAME/slave-agent.jnlp -secret $JENKINS_SECRET -noCertificateCheck
else
	exec java -jar ~/slave.jar -jnlpUrl http://$MASTER_HOST:$MASTER_PORT/computer/$SLAVE_NAME/slave-agent.jnlp
fi
