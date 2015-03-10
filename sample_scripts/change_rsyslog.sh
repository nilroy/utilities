#!/bin/bash
set -o verbose

host=$1
SSH="ssh -o StrictHostKeyChecking=no"
SCP="scp -o StrictHostKeyChecking=no"

$SCP  32-graylog2.conf ${host}:/tmp
$SSH $host "sudo mv /tmp/32-graylog2.conf /etc/rsyslog.d/"
$SSH $host "sudo sed -i.sed '/PreserveFQDN on/d' /etc/rsyslog.conf"
$SSH $host "sudo restart rsyslog" 
