resource "aws_ecr_repository" "app" {
  name         = "hello-world-app"
  force_delete = true # For demo purposes
}
