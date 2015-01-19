#!/bin/bash

volume_id=$1

aws ec2 delete-volume --volume-id $volume_id
