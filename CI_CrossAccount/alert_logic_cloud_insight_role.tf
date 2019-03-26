# Template to deploy the required IAM policy and IAM role for Cloud Insight

#
# IAM Role for Cloud Insight
#
resource "aws_iam_role" "alertlogic_cloud_insight_role" {
  name = "TerraForm_AlertLogic_Cloud_Insight_Role"

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
# IAM Policy for Cloud Insight
#
resource "aws_iam_policy" "alertlogic_cloud_insight_policy" {
  name = "TerraForm_Alertlogic_Cloud_Insight_Policy"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "autoscaling:Describe*",
        "cloudformation:DescribeStack*",
        "cloudformation:GetTemplate",
        "cloudformation:ListStack*",
        "cloudfront:Get*",
        "cloudfront:List*",
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "cloudtrail:ListTags",
        "cloudtrail:LookupEvents",
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
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "EnabledDiscoveryOfVariousAWSServices"
    },
    {
      "Action": [
        "iam:Get*",
        "iam:List*",
        "iam:ListRoles",
        "iam:GetRolePolicy",
        "iam:GetAccountSummary",
        "iam:GenerateCredentialReport"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "EnableInsightDiscovery"
    },
    {
      "Action": [
        "cloudtrail:*"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "EnableCloudTrailIfAccountDoesntHaveCloudTrailsEnabled"
    },
    {
      "Action": [
        "s3:CreateBucket",
        "s3:PutBucketPolicy",
        "s3:DeleteBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::outcomesbucket-*",
      "Sid": "CreateCloudTrailS3BucketIfCloudTrailsAreBeingSetupByAlertLogic"
    },
    {
      "Action": [
        "sns:CreateTopic",
        "sns:DeleteTopic"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:sns:*:*:outcomestopic",
      "Sid": "CreateCloudTrailsTopicTfOneWasntAlreadySetupForCloudTrails"
    },
    {
      "Action": [
        "sns:addpermission",
        "sns:gettopicattributes",
        "sns:listtopics",
        "sns:settopicattributes",
        "sns:subscribe"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:sns:*:*:*",
      "Sid": "MakeSureThatCloudTrailsSnsTopicIsSetupCorrectlyForCloudTrailPublishingAndSqsSubsription"
    },
    {
      "Action": [
        "sqs:CreateQueue",
        "sqs:DeleteQueue",
        "sqs:SetQueueAttributes",
        "sqs:GetQueueAttributes",
        "sqs:ListQueues",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueUrl"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:sqs:*:*:outcomesbucket*",
      "Sid": "CreateAlertLogicSqsQueueToSubscribeToCloudTrailsSnsTopicNotifications"
    },
    {
      "Action": [
        "ec2:CreateTags",
        "ec2:CreateSubnet",
        "ec2:CreateInternetGateway",
        "ec2:AttachInternetGateway",
        "ec2:CreateRoute",
        "ec2:CreateRouteTable",
        "ec2:AssociateRouteTable",
        "ec2:CreateSecurityGroup",
        "ec2:CreateKeyPair",
        "ec2:ImportKeyPair",
        "ec2:CreateNetworkAcl",
        "ec2:CreateNetworkAclEntry",
        "ec2:ReplaceNetworkAclAssociation",
        "ec2:DeleteNetworkAcl",
        "ec2:DeleteRoute"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "EnableAlertLogicSecurityInfrastructureDeployment"
    },
    {
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteNetworkAclEntry",
        "ec2:DeleteRouteTable"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/AlertLogic": "Security"
        }
      },
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ec2:*:*:security-group/*",
        "arn:aws:ec2:*:*:route-table/*",
        "arn:aws:ec2:*:*:network-acl/*"
      ],
      "Sid": "ModifyNetworkSettingsToEnableNetworkVisibilityFromAlertLogicSecurityAppliance"
    },
    {
      "Action": [
        "ec2:DeleteSubnet"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "DeleteSecuritySubnet"
    },
    {
      "Action": [
        "ec2:RunInstances"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ec2:*:*:instance/*",
        "arn:aws:ec2:*:*:volume/*",
        "arn:aws:ec2:*:*:network-interface/*",
        "arn:aws:ec2:*:*:key-pair/*",
        "arn:aws:ec2:*:*:security-group/*"
      ],
      "Sid": "EnsureThatAlertLogicApplianceCanCreateNecessaryResources"
    },
    {
      "Action": [
        "ec2:TerminateInstances",
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/AlertLogic": "Security"
        }
      },
      "Effect": "Allow",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Sid": "EnabletAlertLogicApplianceStateManagement"
    },
    {
      "Action": [
        "autoscaling:CreateLaunchConfiguration",
        "autoscaling:DeleteLaunchConfiguration",
        "autoscaling:CreateAutoScalingGroup",
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:DeleteAutoScalingGroup"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "EnableAlertLogicAutoScalingGroup"
    },
    {
      "Action": [
        "iam:CreateServiceLinkedRole"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:iam::*:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling*",
      "Sid": "EnableCreationOfServiceLinkedRoleForAutoscaling"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

#
# Link policy to role
#
resource "aws_iam_role_policy_attachment" "alertlogic_cloud_insight_attachment" {
  role       = "${aws_iam_role.alertlogic_cloud_insight_role.name}"
  policy_arn = "${aws_iam_policy.alertlogic_cloud_insight_policy.arn}"
}

#
# Set output
#
output "alertlogic_cloud_insight_target_iam_role_arn" {
  value = "${aws_iam_role.alertlogic_cloud_insight_role.arn}"
}
