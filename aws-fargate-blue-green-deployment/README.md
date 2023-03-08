# AWS Fargate Blue Green Deployment

## Create blue environment

```
cd terraform
terraform apply -auto-approve

# test
curl http://bluegreen-alb-1029070231.ap-northeast-1.elb.amazonaws.com/
```

## Switch to green environment

```
# update task definition
terraform apply -var environment="green" -auto-approve

# execute deployment
aws deploy create-deployment \
    --application-name bluegreen-app \
    --deployment-config-name CodeDeployDefault.ECSAllAtOnce \
    --deployment-group-name bluegreen
    --github-location repository=wwalpha/nodejs-examples-for-demo,commitId=string
```
