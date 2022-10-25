variable "name" {
  description = "리소스 기본 이름"
  type        = string
  default     = "first_team_project"
}

variable "azs" {
  description = "가용 영역"
  type        = list(any)
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "pub_cidr" {
  description = "퍼블릭 서브넷 주소"
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "pri_cidr" {
  description = "프라이빗 서브넷 주소"
  type        = list(any)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "pri_cidr2" {
  description = "프라이빗 서브넷2 주소"
  type        = list(any)
  default     = ["10.0.201.0/24", "10.0.202.0/24"]
}

variable "db_user" {
  description = "데이터 베이스 접속 계정"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "데이터 베이스 접속 패스워드"
  type        = string
  default     = "adminpassword"
  sensitive   = true
}
