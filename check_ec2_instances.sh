#!/bin/bash
read -p "Enter aws profile : " profile
#read -p "Enter aws region : " region
ec2_instances=$(aws-okta exec $profile -- aws ec2 describe-instances --filters  "Name=instance-state-name,Values=pending,running,stopped,stopping" --query 'Reservations[*].Instances[*].[State.Name, InstanceId]' --output text | awk '{print $2}')

if [ -z "$ec2_instances" ];
then
echo "No Instances are in AWS";
else
echo "Below instances are still available on $profile account: \n$ec2_instances";
fi
