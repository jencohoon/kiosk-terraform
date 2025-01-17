# CodePipeline Role
resource "aws_iam_role" "codepipeline_new_role" {
  name = "codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

# CodePipeline Policy
resource "aws_iam_policy" "codepipeline_policy" {
  name        = "codepipeline-policy"
  description = "CodePipeline access policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:*"],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = ["codebuild:StartBuild", "codebuild:BatchGetBuilds"],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = "*"
      }
    ]
  })
}

# Attach CodePipeline Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_codepipeline_policy" {
  role       = aws_iam_role.codepipeline_new_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

# CodeBuild Role
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# CodeBuild Policy
resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild-policy"
  description = "CodeBuild access policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:*"],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = ["logs:*"],
        Resource = "*"
      }
    ]
  })
}

# Attach CodeBuild Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}
