# xv_coding_challenge_ryane_c
xv_coding_challenge_ryane_c

## todo:
* Okta integration
* CI/CD 
* fix cloudfront access permission

## nice to haves for a coding challenge
* https support

## Requirements

* aws-cli 2.0.48
* terraform 11.14

## Setting up

* copy and rename `okta.tf.template` to `okta.tf` and fill in the token field
* branch names supported are `staging` and `production` as they are 1:1 mapped to terraform workspaces.