#!/bin/bash
instance_id=$1
aws ec2 terminate-instances --instance-ids $instance_id
