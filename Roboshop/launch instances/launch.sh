#!/bin/bash

COMPONENT=$1

# -z validate the variable empty, true if is empty
if [ -z "${COMPONENT}" ]; then
  echo"Component name is needed"
fi

LID=lt-020b06411441c09c1
LVER=1

DNS_UPDATE(){
 PRIVATEIP=$(aws --region us-east-1 ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].PrivateIpAddress | xargs -n1 )
 sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATEIP}/" record.json >/tmp/record.json
 aws route53 change-resource-record-sets --hosted-zone-id Z1019300110H5BYRDJOPS --change-batch file:///tmp/record.json | jq
}
INSTANCE_STATE=$(aws --region us-east-1 ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].state.Name | xargs -n1 )
if [ "${INSTANCE_STATE}" = "running" ]; then
  echo"Instance is already Existed"
  DNS_UPDATE
  exit 0
fi

if [ "${INSTANCE_STATE}" = "stop" ]; then
  echo"Instance is already Existed"
fi

aws ec2 --region us-east-1 run-instances --launch-template LaunchTemplateId=${LID},Version=${LVER}  --tag-specifications "ResourceType=instance, Tags=[{Key=Name,Value=${COMPONENT}}]" | jq
sleep 30
DNS_UPDATE