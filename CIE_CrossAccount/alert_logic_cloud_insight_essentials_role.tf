# Template to deploy the required IAM policy and IAM role for Cloud Insight Essentials

#
# IAM Role for Cloud Insight Essentials
#
resource "aws_iam_role" "alertlogic_cloud_insight_essentials_role" {
  name = "TerraForm_AlertLogic_Cloud_Insight_Essentials_Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.alert_logic_aws_account_id}:root"
      },
      "Condition": {
        "StringEquals": {"sts:ExternalId": "${var.alert_logic_external_id}"}
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

#
# IAM Policy for Cloud Insight Essentials
#
resource "aws_iam_policy" "alertlogic_cloud_insight_essentials_policy" {
  name = "TerraForm_Alertlogic_Cloud_Insight_Essentials_Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnabledDiscoveryOfVariousAWSServices",
      "Resource": "*",
      "Effect": "Allow",
      "Action": [
        "autoscaling:Describe*",
        "cloudformation:DescribeStack*",
        "cloudformation:GetTemplate",
        "cloudformation:ListStack*",
        "cloudfront:Get*",
        "cloudfront:List*",
        "cloudwatch:Describe*",
        "config:DeliverConfigSnapshot",
        "config:Describe*",
        "config:Get*",
        "config:ListDiscoveredResources",
        "cur:DescribeReportDefinitions",
        "directconnect:Describe*",
        "dynamodb:ListTables",
        "ec2:Describe*",
        "elasticbeanstalk:Describe*",
        "elasticache:Describe*",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:DescribeJobFlows",
        "events:Describe*",
        "events:List*",
        "glacier:ListVaults",
        "guardduty:Get*",
        "guardduty:List*",
        "kinesis:Describe*",
        "kinesis:List*",
        "kms:DescribeKey",
        "kms:GetKeyPolicy",
        "kms:GetKeyRotationStatus",
        "kms:ListAliases",
        "kms:ListGrants",
        "kms:ListKeys",
        "kms:ListKeyPolicies",
        "kms:ListResourceTags",
        "lambda:List*",
        "logs:Describe*",
        "rds:Describe*",
        "rds:ListTagsForResource",
        "redshift:Describe*",
        "route53:GetHostedZone",
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "sdb:DomainMetadata",
        "sdb:ListDomains",
        "sns:ListSubscriptions",
        "sns:ListSubscriptionsByTopic",
        "sns:ListTopics",
        "sns:GetEndpointAttributes",
        "sns:GetSubscriptionAttributes",
        "sns:GetTopicAttributes",
        "s3:ListAllMyBuckets",
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:GetBucket*",
        "s3:GetLifecycleConfiguration",
        "s3:GetObjectAcl",
        "s3:GetObjectVersionAcl",
        "tag:GetResources",
        "tag:GetTagKeys"
      ]
    },
    {
      "Sid": "EnableInsightDiscovery",
      "Resource": "*",
      "Effect": "Allow",
      "Action": [
        "iam:Get*",
        "iam:List*",
        "iam:GenerateCredentialReport"
      ]
    },
    {
      "Sid": "EnableCloudTrailIfAccountDoesntHaveCloudTrailsEnabled",
      "Resource": "*",
      "Effect": "Allow",
      "Action": [
        "cloudtrail:Describe*",
        "cloudtrail:Get*",
        "cloudtrail:List*",
        "cloudtrail:LookupEvents",
        "cloudtrail:StartLogging",
        "cloudtrail:UpdateTrail"
      ]
    },
    {
      "Sid": "CreateCloudTrailS3BucketIfCloudTrailsAreBeingSetupByAlertLogic",
      "Resource": "arn:aws:s3:::outcomesbucket-*",
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:PutBucketPolicy",
        "s3:DeleteBucket"
      ]
    },
    {
      "Sid": "CreateCloudTrailsTopicTfOneWasntAlreadySetupForCloudTrails",
      "Resource": "arn:aws:sns:*:*:outcomestopic",
      "Effect": "Allow",
      "Action": [
        "sns:CreateTopic",
        "sns:DeleteTopic"
      ]
    },
    {
      "Sid": "MakeSureThatCloudTrailsSnsTopicIsSetupCorrectlyForCloudTrailPublishingAndSqsSubsription",
      "Resource": "arn:aws:sns:*:*:*",
      "Effect": "Allow",
      "Action": [
        "sns:AddPermission",
        "sns:GetTopicAttributes",
        "sns:ListTopics",
        "sns:SetTopicAttributes",
        "sns:Subscribe"
      ]
    },
    {
      "Sid": "CreateAlertLogicSqsQueueToSubscribeToCloudTrailsSnsTopicNotifications",
      "Resource": "arn:aws:sqs:*:*:outcomesbucket*",
      "Effect": "Allow",
      "Action": [
        "sqs:CreateQueue",
        "sqs:DeleteQueue",
        "sqs:SetQueueAttributes",
        "sqs:GetQueueAttributes",
        "sqs:ListQueues",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueUrl"
      ]
    }
  ]
}
EOF
}

#
# Link policy to role
#
resource "aws_iam_role_policy_attachment" "alertlogic_cloud_insight_essentials_attachment" {
  role       = "${aws_iam_role.alertlogic_cloud_insight_essentials_role.name}"
  policy_arn = "${aws_iam_policy.alertlogic_cloud_insight_essentials_policy.arn}"
}

#
# Set output
#
output "alertlogic_cloud_insight_essentials_target_iam_role_arn" {
  value = "${aws_iam_role.alertlogic_cloud_insight_essentials_role.arn}"
}
