#Variables Declarations

provider "aws" {
  profile = "pst"
}

#
# This is the AWS Account id for Alert Logic
#
variable "alert_logic_aws_account_id" {
  type        = "string"
  description = "Alert Logic AWS trusted account."
  default     = "733251395267"                     # use 857795874556 for deployments in the UK DC
}

#
# External ID for Cross Account
#
variable "alert_logic_external_id" {
  type        = "string"
  description = "Your Alert Logic account ID."
}
