#Variables Declarations

#
# This is the AWS Account id for Alert Logic
#
variable "alert_logic_aws_account_id" {
  type = "string"
}

#
# External ID for Cross Account
#
variable "alert_logic_external_id" {
  type = "string"
}

#
# SNS arn from the CloudTrail
#
variable "cloudtrail_sns_arn" {
  type = "string"
}

#
# S3 bucket name where the CloudTrail stored
#
variable "cloudtrail_s3" {
  type = "string"
}

#
# This is the AWS Account id for Alert Logic
#
variable "alert_logic_lm_aws_account_id" {
  type = "string"
}