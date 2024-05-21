#!/bin/bash

# describe profile id
profileId=$(aws route53profiles list-profiles | jq -r .ProfileSummaries[0].Id)

# associate profile
aws route53profiles disassociate-profile --profile-id $profileId --resource-id $RESOURCE_ID
