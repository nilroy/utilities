#!/bin/bash
instance_id=$1
aws ec2 describe-instances --instance-ids $instance_id
