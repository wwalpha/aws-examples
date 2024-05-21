#!/bin/bash

# describe profile id
profileId=$(aws route53profiles list-profiles | jq -r .ProfileSummaries[0].Id)

# delete profile
aws route53profiles delete-profile --profile-id $profileId
