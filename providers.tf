terraform {
  backend "s3" {
    bucket         = "florence-state"
    dynamodb_table = "florence-state-lock-dynamo"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
  }

  required_version = "~> 1.5.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


}

provider "aws" {
  region = "eu-west-2"
}