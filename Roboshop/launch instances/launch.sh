#!/bin/bash

COMPONENT=$1

# -z validate the variable empty, true if is empty
if [ -z "$(COMPONENT)" ]; then
  echo "Component name is needed"
  fi

  LID=1t-
  LVER=1

  DNS_UPDATE() {
    PRIVATEIP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservation[].Instances[].PrivateIpaddress | xargs -n1 )
    sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATEIP}/" record.json
    aws route53 change-resources-record-sets --hosted-zone-id Z0853472YEV9ELZNQML9 --change-batch file://tmp/record.json | jq
    }
    INSTANCE_STATE=${aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].state.Name | xargs -n1 }
    if [ "${INSTANCE_STATE}" = "running" ]; then
      echo "Instance is already Existed"
      DNS_UPDATE
      exit 0
      fi

      if ["${INSTANCE_STATE}" = "stop" ]; then
        echo"Instance is already Existed"
      fi

      aws ec2 run-instances --launch-template LaunchTemplateID=${LID},Version=${LVER} --tag-specifications "ResourceType+Instance, Tags=[{Key=Name,Value=${COMPONENT} } ]' | jq
      sleep 30
      DNS_UPDATE
