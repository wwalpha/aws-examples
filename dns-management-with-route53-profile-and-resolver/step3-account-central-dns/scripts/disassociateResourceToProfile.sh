#!/bin/bash

# describe profile id
profileId=$(aws route53profiles list-profiles | jq -r .ProfileSummaries[0].Id)

echo $profileId
# disassociate profile
aws route53profiles disassociate-resource-from-profile --profile-id $profileId --resource-arn $RESOURCE_ARN_HOSTED_ZONE1
aws route53profiles disassociate-resource-from-profile --profile-id $profileId --resource-arn $RESOURCE_ARN_HOSTED_ZONE2
aws route53profiles disassociate-resource-from-profile --profile-id $profileId --resource-arn $RESOURCE_ARN_RESOLVER_RULE1
aws route53profiles disassociate-resource-from-profile --profile-id $profileId --resource-arn $RESOURCE_ARN_RESOLVER_RULE2
