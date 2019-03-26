# Template to deploy the required IAM policy and IAM role for Threat Manager

#
# IAM Role for Threat Manager
#
resource "aws_iam_role" "alertlogic_tm_role" {
  name = "TerraForm_AlertLogic_Threat_Manager_Role"

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
# IAM Policy for Threat Manager
#
resource "aws_iam_policy" "alertlogic_tm_policy" {
  name = "TerraForm_Alertlogic_Threat_Manager_Policy"

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
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetEventSelectors",
        "cloudtrail:GetTrailStatus",
        "cloudtrail:ListPublicKeys",
        "cloudtrail:ListTags",
        "cloudtrail:LookupEvents",
        "cloudtrail:StartLogging",
        "cloudtrail:UpdateTrail"
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
        "sqs:ListQueues"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "BeAbleToListSQSForCloudTrail"
    },
    {
      "Action": [
        "ec2:GetConsoleOutput",
        "ec2:GetConsoleScreenShot",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/AlertLogic": "Security"
        }
      },
      "Effect": "Allow",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Sid": "EnableAlertLogicApplianceStateManagement"
    },
    {
      "Action": [
        "autoscaling:UpdateAutoScalingGroup"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/AlertLogic": "Security"
        }
      },
      "Effect": "Allow",
      "Resource": "arn:aws:autoscaling:*:*:autoScalingGroup/*",
      "Sid": "EnableAlertLogicAutoScalingGroupManagement"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

#
# Link policy to role
#
resource "aws_iam_role_policy_attachment" "alertlogic_tm_attachment" {
  role       = "${aws_iam_role.alertlogic_tm_role.name}"
  policy_arn = "${aws_iam_policy.alertlogic_tm_policy.arn}"
}

#
# Set output
#
output "alertlogic_tm_target_iam_role_arn" {
  value = "${aws_iam_role.alertlogic_tm_role.arn}"
}
