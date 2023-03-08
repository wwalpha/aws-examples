# AWS Fargate Blue Green Deployment

## Create blue environment

```
$ terraform init
$ terraform apply -auto-approve

app_url = "http://bluegreen-alb-99999999.ap-northeast-1.elb.amazonaws.com/"
appspec_s3_location = "bucket=bluegreen-configs,bundleType=yaml,eTag=525211c1fddb460e77a69541760fb74c,key=appspec.yaml"
codedeploy_application = "bluegreen-app"
codedeploy_deployment_group_name = "bluegreen"
ecs_cluster_name = "bluegreen-cluster"
ecs_service_name = "bluegreen-service"
ecs_task_definition_name = "bluegreen-task"

# test
curl http://bluegreen-alb-99999999.ap-northeast-1.elb.amazonaws.com/
```

## Switch to green environment

```
# update task definition to green version
$ terraform apply -var environment="green" -auto-approve

# execute deployment
$ aws deploy create-deployment \
    --application-name bluegreen-app \
    --deployment-config-name CodeDeployDefault.ECSAllAtOnce \
    --deployment-group-name bluegreen \
    --s3-location bucket=bluegreen-configs,bundleType=yaml,key=appspec.yaml

{
    "deploymentId": "d-XXXXXXXX"
}

# confirm deployment success
$ aws deploy get-deployment --deployment-id d-2PBMOJKRM
```

## Destroy environment

```
$ terraform apply -destroy -auto-approve
```
