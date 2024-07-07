locals {
  aws_account_id = data.external.aws_account_id.result["account_id"]
}

output "account_id" {
  value = local.aws_account_id
}


resource "aws_s3_bucket" "velero_bucket" {
  bucket = "velero-s3-bucket"

  tags = {
    Name        = "EKS-Velero"
    Environment = "Dev"
  }
}

resource "aws_iam_policy" "velero-policy" {
  name = "VeleroAccessPolicy"
  path = "/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeVolumes",
          "ec2:DescribeSnapshots",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.velero_bucket.bucket}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.velero_bucket.bucket}"
        ]
      }
    ]
  })
}


resource "aws_iam_role" "eks-velero-backup" {
  name = "eks-velero-backup"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${local.aws_account_id}:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/${element(split("/", module.eks.oidc_provider_arn), 3)}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.us-west-2.amazonaws.com/id/${element(split("/", module.eks.oidc_provider_arn), 3)}:aud" : "sts.amazonaws.com",
            "oidc.eks.us-west-2.amazonaws.com/id/${element(split("/", module.eks.oidc_provider_arn), 3)}:sub" : "system:serviceaccount:velero:velero",
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "velero_role_policy_attachment" {
  role       = aws_iam_role.eks-velero-backup.name
  policy_arn = aws_iam_policy.velero-policy.arn
}
