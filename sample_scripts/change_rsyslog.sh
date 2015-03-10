#!/bin/bash

hostfile=$1
SSH="ssh -o StrictHostKeyChecking=no"
SCP="scp -o StrictHostKeyChecking=no"

function change_rsyslog() {
host=$1
echo "Current server ${host}"
echo "Uploading 32-graylog2.conf"
$SCP  32-graylog2.conf ${host}:/tmp || return 1
$SSH $host "sudo mv /tmp/32-graylog2.conf /etc/rsyslog.d/" || return 1
echo "Modifying rsyslog.conf"
$SSH $host "sudo sed -i.sed '/PreserveFQDN on/d' /etc/rsyslog.conf" || return 1
echo "Restarting rsyslog"
$SSH $host "sudo restart rsyslog" || return 1
echo "***********Finished**********"
return 0
}

for host in $(cat $hostfile)
do
   change_rsyslog $host
done
