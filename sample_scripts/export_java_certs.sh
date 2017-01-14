#!/bin/bash

cert_list=$1
keystore_file="/usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts"
keystore_pass="changeit"
output_dir="/root/certs"
IFS="
"

if [ ! -d "$output_dir" ] ; then
  mkdir -m 755 -p $output_dir
fi

for cert_detail in $(cat $cert_list | grep -v "^#") ; do
  cert_name=$(echo $cert_detail | awk -F";" '{print $1}' | xargs basename)
  cert_alias=$(echo $cert_detail | awk -F";" '{print $2}')
  keytool -export -keystore $keystore_file -storepass $keystore_pass -alias $cert_alias -file ${output_dir}/${cert_name}
done
