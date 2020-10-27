# xv_coding_challenge_ryane_c
xv_coding_challenge_ryane_c

## todo:
* Okta integration
* fix cloudfront access permission

## caveats
CI/CD won't work unless the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are provided in the repo environment settings

## nice to haves for a coding challenge
* https support

## Requirements
* aws-cli 2.0.48 or later
* terraform 0.12.25 or later
* yarn 1.0 or later

## Setting up
This repo is intended to be cloned, you will need to initialise your infrastructure with
```
yarn infra:init
```
* branch names supported for deployment are `staging` and `production` as they are 1:1 mapped to terraform workspaces.


To retrieve the cloudfront url of the microsite run
```
yarn get-url:[staging|production]
```
* copy and rename `okta.tf.template` to `okta.tf` and fill in the token field


## Decommissioning
Run
```
yarn infra:destroy
```
_disclaimer: doesn't actually correctly account for tearing down workspaces_

### Time logs
* configuring basic infra using terraform - 1 hrs
* finding a cloudfront + s3 terraform module - 30 mins
* configuring cloudfront lambda + verifying - 45 mins
* figuring out how to okta - 2 hrs
* setting up github actions CI/CD - 20 mins
* bootscripts and instructions - 45 mins