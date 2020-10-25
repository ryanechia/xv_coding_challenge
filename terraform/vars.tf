
variable "application" {
  default = "MyMicrosite"
}

locals {
  environment = terraform.workspace
}