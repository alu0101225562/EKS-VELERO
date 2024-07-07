data "external" "aws_account_id" {
  program = [
    "bash", "-c", "account_id=$(aws sts get-caller-identity --output text --query 'Account'); printf '{\"account_id\": \"%s\"}' $account_id"
  ]
}
