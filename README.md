# xv_coding_challenge_ryane_c
This repo is intended to be used as a boilerplate, and has a central s3 bucket specifically to store and retrieve the okta API key. (I just don't want to introduce yet another integration point for this exercise) 

It will spin up the infrastructure in the following ways: 

* S3 - static web hosting
* Cloudfront - CDN with trigger ability
* lambda@edge - the actual trigger

CI/CD is set up to use github actions which will upload the contents of the `src` folder to s3 

Cloning implementations of this repo will maintain staging/production environment infrastructure through terraform.
If the terraform files are generally untouched the CI/CD will handle state management, however `yarn` scripts are provided
for manual deployment if need be.

## Caveats
* CI/CD won't work unless the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are provided in the github repo environment settings
* Okta lambda generated using https://github.com/Widen/cloudfront-auth probably using incorrect settings
* OKTA API docs do not have details to create and add a OpenID web application
    * `yarn generate-okta-app` will generate a app but of the wrong kind
* cloudfront access to private s3 file unverified due to missing okta
    * also suspect the `aws_iam_role` may be ineffective
* route53 and other CNAMEs for cloudfront setup were skipped intentionally, but the cloudfront URL will be printed to 
console and is retrievable through `yarn get-url:[staging|production]`

## Requirements
* aws-cli 2.0.48 or later
* terraform 0.12.25 or later
* yarn 1.0 or later

## Setting up
Your static website code goes into the `src` folder. Don't forget to include a `index.html`!

You will need to initialise a new project's infrastructure with
```
yarn infra:init
```
*Note*: branch names supported for deployment are `staging` and `production` as they are 1:1 mapped to terraform workspaces.

To retrieve the cloudfront url of the microsite run
```
yarn get-url:[staging|production]
```

see `package.json` for other convenience scripts to interact with the infrastructure


## Decommissioning
Run
```
yarn infra:destroy
```
_disclaimer: doesn't actually correctly account for tearing down workspaces_

### Time logs
* configuring basic infra using terraform - 1 hr
* finding a cloudfront + s3 terraform module - 30 mins
* configuring cloudfront lambda + verifying - 45 mins
* figuring out how to okta - 2 hrs
* setting up github actions CI/CD - 20 mins
* bootscripts and instructions - 45 mins
* okta API key storage + okta app generator - 1 hr
* summary readme - 30 mins