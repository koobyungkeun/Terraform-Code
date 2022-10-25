# 프로바이더 및 state 파일 원격백엔드 설정
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
  backend "s3" {
    bucket         = "first-team-project"
    key            = "terraform/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "first_team_project_terraform_state_lock"
    encrypt        = true
  }
}

# 리전 설정
provider "aws" {
  region = "ap-southeast-2"
}
