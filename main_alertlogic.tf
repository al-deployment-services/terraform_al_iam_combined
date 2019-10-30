# Alert Logic sample Terraform template for deploying:
# 1. Threat Manager Cross Account Role
# 2. Cloud Insight Cross Account Role
# 3. Log Manager Cloud Trail Cross Account Role + SQS

provider "aws" {
  profile = "default"
  region  = "us-west-2"
  version = "~> 2.33"
}

#
# Module for Cloud Insight Cross Account Role
# Output the IAM role ARN to be inputed back to Alert Logic Cloud Insight UI
#
module "cloud_insight_role" {
  source                     = "./CI_CrossAccount"
  alert_logic_aws_account_id = "${var.alert_logic_aws_account_id}"
  alert_logic_external_id    = "${var.alert_logic_external_id}"
}

module "cloud_insight_essentials_role" {
  source                     = "./CIE_CrossAccount"
  alert_logic_aws_account_id = "${var.alert_logic_aws_account_id}"
  alert_logic_external_id    = "${var.alert_logic_external_id}"
}

#
# Module for Threat Manager Cross Account Role
# Output the IAM role ARN to be inputed back to Alert Logic Cloud Defender UI
#
module "threat_manager_role" {
  source                     = "./TM_CrossAccount"
  alert_logic_aws_account_id = "${var.alert_logic_aws_account_id}"
  alert_logic_external_id    = "${var.alert_logic_external_id}"
}

#
# Module for Log Manager Cross Account Role
# Output the IAM role ARN and SQS name to be inputed back to Alert Logic Log Manager Cloud Trail source
#
module "log_manager_cloudtrail" {
  source                        = "./LM_CloudTrail"
  alert_logic_aws_account_id    = "${var.alert_logic_aws_account_id}"
  alert_logic_external_id       = "${var.alert_logic_external_id}"
  cloudtrail_sns_arn            = "${var.cloudtrail_sns_arn}"
  cloudtrail_s3                 = "${var.cloudtrail_s3}"
  alert_logic_lm_aws_account_id = "${var.alert_logic_lm_aws_account_id}"
}

#
# Outputs
#
output "alertlogic_tm_target_iam_role_arn" {
  value = "${module.threat_manager_role.alertlogic_tm_target_iam_role_arn}"
}

output "alertlogic_lm_cloudtrail_target_iam_role_arn" {
  value = "${module.log_manager_cloudtrail.alertlogic_lm_cloudtrail_target_iam_role_arn}"
}

output "alertlogic_lm_cloudtrail_target_sqs_name" {
  value = "${module.log_manager_cloudtrail.alertlogic_lm_cloudtrail_target_sqs_name}"
}

output "alertlogic_cloud_insight_target_iam_role_arn" {
  value = "${module.cloud_insight_role.alertlogic_cloud_insight_target_iam_role_arn}"
}

output "alertlogic_cloud_insight_essentials_target_iam_role_arn" {
  value = "${module.cloud_insight_essentials_role.alertlogic_cloud_insight_essentials_target_iam_role_arn}"
}
