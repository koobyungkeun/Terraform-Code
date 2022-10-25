# state 파일 백엔드 용도의 S3 버킷 생성
resource "aws_s3_bucket" "terraform_state" {
  bucket = "first-team-project"
}

# S3 버킷 버전 관리 활성화
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# state lock 설정 용도의 dynamodb table 생성
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "first_team_project_terraform_state_lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
