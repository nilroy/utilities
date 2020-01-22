#!/bin/bash

source_env=$1
destination_env=$2

IFS="
"

function main() {
  for p in $(aws ssm --region us-east-1 describe-parameters --parameter-filters Key=KeyId,Values="alias/${source_env}/ssm" | jq -r -c '.Parameters[]'); do
    old_param_name=$(echo $p | jq -r ".Name")
    description=$(echo $p | jq -r ".Description")
    type=$(echo $p | jq -r ".Type")
    new_param_name=$(echo $old_param_name | sed 's/'"${source_env}"'/'"${destination_env}"'/g')
    parameter_value=$(aws ssm --region us-east-1 get-parameter --name ${old_param_name} --with-decryption | jq -r '.Parameter.Value')
    echo "Copying $old_param_name to $new_param_name using encryption key alias/${destination_env}/ssm"
    aws ssm --region us-east-1 put-parameter --name "$new_param_name" --value "${parameter_value}" --type $type --description $description --key-id alias/${destination_env}/ssm --overwrite || break
  done
}

main
