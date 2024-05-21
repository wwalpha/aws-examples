#!/bin/bash

# describe profile id
profileId=$(aws route53profiles list-profiles | jq -r .ProfileSummaries[0].Id)

aws route53profiles associate-resource-to-profile --name $RESOURCE_ID_HOSTED_ZONE1 --profile-id $profileId --resource-arn $RESOURCE_ARN_HOSTED_ZONE1

aws route53profiles associate-resource-to-profile --name $RESOURCE_ID_HOSTED_ZONE2 --profile-id $profileId --resource-arn $RESOURCE_ARN_HOSTED_ZONE2

aws route53profiles associate-resource-to-profile --name $RESOURCE_ID_RESOLVER_RULE1 --profile-id $profileId --resource-arn $RESOURCE_ARN_RESOLVER_RULE1

aws route53profiles associate-resource-to-profile --name $RESOURCE_ID_RESOLVER_RULE2 --profile-id $profileId --resource-arn $RESOURCE_ARN_RESOLVER_RULE2
