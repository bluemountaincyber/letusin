terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.19.0"
    }
  }
}

variable "blue_mountain_aws_account_id" {
  description = "The AWS account ID for Blue Mountain"
  type        = string
  default     = "480832961394"
}

data "aws_iam_policy" "security_audit" {
  arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role" "read_only_role" {
  name               = "BlueMountainCyberRole"
  assume_role_policy = data.aws_iam_policy_document.read_only_assume_role_policy.json
  description        = "Role to provide read-only access to AWS resources for Blue Mountain"
}

data "aws_iam_policy_document" "read_only_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.blue_mountain_aws_account_id}:root"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "read_only_role_attachment" {
  role       = aws_iam_role.read_only_role.name
  policy_arn = data.aws_iam_policy.security_audit.arn
}

output "read_only_role_arn" {
  description = "The ARN of the read-only IAM role for Blue Mountain"
  value       = aws_iam_role.read_only_role.arn
}
