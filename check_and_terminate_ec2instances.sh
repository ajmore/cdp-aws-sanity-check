#!/bin/bash
read -p "Enter aws profile : " profile
ec2_instances=$(aws-okta exec $profile -- aws ec2 describe-instances --filters  "Name=instance-state-name,Values=pending,running,stopped,stopping" --query 'Reservations[*].Instances[*].[State.Name, InstanceId]' --output text | awk '{print $2}')
if [ -z "$ec2_instances" ];
then
echo "No Instances are in AWS";
else
echo "Below instances are still available on $profile account: \n$ec2_instances";
read -p "Do you want to delete available ec2 instances [y/n] : " delete ## Terminating the instances if y or Y is pressed. Any other key would cancel it. It's safer this way.
  if [[ $delete == [yY] ]]; then
    for i in $ec2_instances
          do
            echo "Terminating ec2 instance with ID: $i \n"
            aws-okta exec $profile -- aws ec2 terminate-instances --instance-ids $i ## It is actually Terminating the $i Instances.
          done
    fi
echo "Also check number of Volumes/Disks are available in AWS or already deleted successfully. (Run ./check_volumes.sh)";
fi
