# florence
sample terraform for technical interview


## Requirements
Dev-Ops Technical Interview Brief:

Pre-requisites:

You should have a personal AWS account set-up (this can be a free-tier account which you should be able to set-up if you do not already have one).

The Task:

The goal is to create some infrastructure that is easily maintainable and deployable using infrastructure as code.

With that in mind, please complete the following steps:

1. Create limited access IAM roles in the AWS account so that we can see the dashboards. These accounts should be for: · Telmo Sampaio – elmo.sampaio@generatehealth.com · Kashif Ahmed - kashif.ahmed@generatedhealth.com · Vicente Manzano - vicente.manzano@generatedhealth.com

2. Create a private S3 bucket

3. Set up logging and alerting on this S3 bucket. We would like you to demonstrate your skills in setting these up, however as a minimum we would like the following:

· To receive an email alert when a file is added to the S3 bucket (please refrain from enabling these to our inboxes before the interview!)

· A dashboard on AWS which displays bucket usage data (e.g., reads and writes)

4. Create an ec2 instance to act as a ‘bastion host’ which can be used for CRUD operations on the bucket (how these are done is up to you).

5. Log connections to this ec2 instance and display these in a dashboard (extension: set up users on the server to audit who is connecting)

6. IP limit the connections that can access the ec2 instance (we will ask for our IPs to then be whitelisted prior to the interview).

7. Create an architecture diagram of what has been built

It is not necessary to complete everything above (you may also add some additional steps that you feel could be useful to show us your skills), we will review using the accounts you create for us and will discuss your approach and architecture decisions with you in the interview.

Also, once you have completed the above, please can you share your infrastructure templates with us via GitHub. (This can be by either creating and sharing a repo or creating a Gist and sending us the link)
