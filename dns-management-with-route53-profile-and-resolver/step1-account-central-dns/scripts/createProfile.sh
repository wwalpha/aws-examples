#!/bin/bash

profileId=$(aws route53profiles create-profile --name $PROFILE_NAME | jq -r '.Profile.Id')
