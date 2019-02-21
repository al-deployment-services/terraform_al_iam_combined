# Template to deploy the required IAM policy and IAM role for manual deployments in AWS

#
# IAM Role for manual deployment
#
resource "aws_iam_role" "alertlogic_manual_role" {
  name = "TerraForm_alertlogic_manual_role"

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
# IAM Policy for manual deployment
#
resource "aws_iam_policy" "alertlogic_manual_policy" {
  name = "TerraForm_alertlogic_manual_policy"

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
				"cloudtrail:DescribeTrails",
				"cloudtrail:GetTrailStatus",
				"cloudtrail:LookupEvents",
				"cloudtrail:ListTags",
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
				"iam:ListRoles",
				"iam:GetRolePolicy",
				"iam:GetAccountSummary",
				"iam:GenerateCredentialReport"
			]
		},
		{
			"Sid": "LimitedCloudTrail",
			"Resource": "*",
			"Effect": "Allow",
			"Action": [
				"cloudtrail:DescribeTrails",
				"cloudtrail:GetTrailStatus",
				"cloudtrail:ListPublicKeys",
				"cloudtrail:ListTags",
				"cloudtrail:LookupEvents"
			]
		},
		{
			"Sid": "LimitedSNSForCloudTrail",
			"Resource": "arn:aws:sns:*:*:*",
			"Effect": "Allow",
			"Action": [
				"sns:listtopics",
				"sns:gettopicattributes",
				"sns:subscribe"
			]
		},
		{
			"Sid": "LimitedSQSForCloudTrail",
			"Resource": "arn:aws:sqs:*:*:outcomesbucket*",
			"Effect": "Allow",
			"Action": [
				"sqs:GetQueueAttributes",
				"sqs:ReceiveMessage",
				"sqs:DeleteMessage",
				"sqs:GetQueueUrl"
			]
		},
		{
			"Sid": "BeAbleToListSQSForCloudTrail",
			"Resource": "*",
			"Effect": "Allow",
			"Action": [
				"sqs:ListQueues"
			]
		},
		{
			"Sid": "EnableAlertLogicApplianceStateManagement",
			"Resource": "arn:aws:ec2:*:*:instance/*",
			"Effect": "Allow",
			"Condition": {
				"StringEquals": {
					"ec2:ResourceTag/AlertLogic": "Security"
				}
			},
			"Action": [
				"ec2:GetConsoleOutput",
				"ec2:GetConsoleScreenShot",
				"ec2:StartInstances",
				"ec2:StopInstances",
				"ec2:TerminateInstances"
			]
		},
		{
			"Sid": "EnableAlertLogicAutoScalingGroupManagement",
			"Resource": "arn:aws:autoscaling:*:*:autoScalingGroup/*",
			"Effect": "Allow",
			"Condition": {
				"StringEquals": {
					"ec2:ResourceTag/AlertLogic": "Security"
				}
			},
			"Action": [
				"autoscaling:UpdateAutoScalingGroup"
			]
		}
	]
}
EOF
}

#
# Link policy to role
#
resource "aws_iam_role_policy_attachment" "alertlogic_cloud_insight_attachment" {
  role       = "${aws_iam_role.alertlogic_manual_role.name}"
  policy_arn = "${aws_iam_policy.alertlogic_manual_policy.arn}"
}

#
# Set output
#
output "alertlogic_manual_target_iam_role_arn" {
  value = "${aws_iam_role.alertlogic_manual_role.arn}"
}
