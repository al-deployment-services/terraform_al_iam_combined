Sample Terraform to deploy Alert Logic related IAM roles
=================
This is collections of modules to deploy: 

- Cloud Insight IAM Policy + Role
- Threat Manager IAM Policy + Role
- Log Manager Cloud Trail IAM Policy + Role and SQS

Requirements
------------
* Alert Logic Account ID (CID)
* Cloud Trail must be enabled and set to All Regions
* Cloud Trail must have SNS topic (if you plan to use Log Manager Cloud Trail collection)

Variables
----------
* `alert_logic_aws_account_id` - AWS account number for Cloud Insight and Threat Manager, default to 733251395267
* `alert_logic_lm_aws_account_id` - AWS account number for Log Manager, default to 239734009475
* `alert_logic_external_id` - External ID for IAM Cross Account Role, use some random number or your Alert Logic Customer ID
* `cloudtrail_sns_arn` - SNS arn that is used by CloudTrail
* `cloudtrail_s3` - S3 bucket name where the CloudTrail stored

License and Authors
===================
License:
Distributed under the Apache 2.0 license.

Authors: 
Welly Siauw (welly.siauw@alertlogic.com)