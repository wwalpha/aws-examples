# ----------------------------------------------------------------------------------------------
# AWS SSM Document - Approve
# ----------------------------------------------------------------------------------------------
resource "aws_ssm_document" "approve" {
  name            = "${local.prefix}-UserApprove"
  document_type   = "Automation"
  document_format = "YAML"

  content = <<DOC
schemaVersion: '0.3'
parameters:
  taskToken:
    type: String
  buildId:
    type: String
mainSteps:
  - name: Publish
    action: aws:executeAwsApi
    nextStep: UserApprove
    isEnd: false
    inputs:
      Subject: CloudWatch Agent Config Validation Request Approve
      TopicArn: ${aws_sns_topic.nofity.arn}
      Service: sns
      Api: Publish
      Message: |-
        ApproveURL: https://{{ global:REGION }}.console.aws.amazon.com/systems-manager/automation/execution/{{ automation:EXECUTION_ID }}/approval

        CodeBuild Project: https://{{ global:REGION }}.console.aws.amazon.com/codesuite/codebuild/{{ global:ACCOUNT_ID }}/projects/monitoringBuildProject/build/{{ buildId }}
  - name: UserApprove
    action: aws:approve
    timeoutSeconds: 1800
    nextStep: Branch
    isEnd: false
    inputs:
      Approvers:
        - ${var.approver}
  - name: Branch
    action: aws:branch
    inputs:
      Choices:
        - NextStep: SendTaskFailure
          Variable: '{{ UserApprove.ApprovalStatus }}'
          StringEquals: Approve
      Default: SendTaskSuccess
  - name: SendTaskSuccess
    action: aws:executeAwsApi
    isEnd: true
    inputs:
      Service: stepfunctions
      Api: SendTaskSuccess
      taskToken: '{{ taskToken }}'
      output: '{}'
  - name: SendTaskFailure
    action: aws:executeAwsApi
    isEnd: true
    inputs:
      Service: stepfunctions
      Api: SendTaskFailure
      taskToken: '{{ taskToken }}'
outputs:
  - UserApprove.ApproverDecisions
  - UserApprove.ApprovalStatus
DOC

  lifecycle {
    ignore_changes = [content]
  }
}
