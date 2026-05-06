End-to-End CI/CD with Git, GitHub
Actions & Terraform 
LAB OVERVIEW (when choosing the mode before entering the lab):
    In this lab, you will build an automated, version-controlled deployment pipeline for a serverless AWS data architecture. You will bypass manual console clicking and instead define your entire infrastructure—Amazon S3, AWS Lambda, Amazon DynamoDB, and AWS Glue—using Terraform. You will manage this code using advanced Git workflows, handling branching, merging, and remote synchronization. Finally, you will bridge version control and infrastructure as code (IaC) by implementing a CI/CD pipeline using GitHub Actions. This simulates a mature engineering environment where code changes are safely tested, planned, and automatically applied to the cloud, ensuring high reliability and reproducibility.
     What You’ll Learn
How to leverage the core Git workflow to track changes, manage branches, resolve conflicts, and safely undo mistakes.
How to write complex Terraform configurations using HCL syntax, defining Providers, Resources, and Data Sources.
How to manage Terraform data dynamically using Variables, Locals, and Outputs.
How to structure Terraform projects for enterprise scale using Remote State, State Locking, Workspaces, and Modules.
How to enforce safety in IaC using input validation, loops (count/for_each), and lifecycle rules.
How to automate the Terraform workflow (Init, Plan, Apply) using GitHub Actions.


Task 1: The Basics of Git & The Core Workflow
Steps:
Open your local terminal and create a dedicated workspace directory.
Initialise a new Git repository and configure a .gitignore file.
Stage and commit your initial setup.
Review the timeline of your actions.
mkdir aws-data-cicd
cd aws-data-cicd

# Initialise the repository
git init


# Create a .gitignore file
echo "*.terraform*" > .gitignore
echo "*.tfstate*" >> .gitignore
echo "terraform.tfvars" >> .gitignore
echo ".DS_Store" >> .gitignore


# Check the status of the Working Directory
git status

# Move changes to the Staging Area
git add .gitignore

# Save a snapshot to the Repository
git commit -m "chore: initial commit and gitignore setup."

# View the timeline of past saves
git log --oneline

Git initializes a repository using git init, which enables it to track every change within a folder. The Git workflow involves three core states:
Working Directory: Where you actively make and edit files.
Staging Area: An intermediate space managed by git add, used to group specific changes before committing them.
Repository: The permanent storage where Git commits save a complete snapshot of the staged changes, along with a descriptive message.
To manage the repository effectively, two commands are essential:
git status: Shows the current state of your files and the tracking status.
git log: Displays the complete history and timeline of all committed snapshots.
A crucial configuration is the .gitignore file. It prevents Git from tracking unwanted files, such as large temporary data or sensitive information like passwords or keys, often found in configuration files (e.g., terraform.tfvars).

Task 2: Branching, Merging, and Undoing Mistakes
Steps:
Create a branch to isolate new feature development.
Introduce a deliberate mistake, then safely undo it before committing.
Revert an old commit.
Merge your feature branch back to the main timeline.
# Create a parallel universe to test new features
git checkout -b feature/iac-setup

# Simulating a mistake in the Working Directory
echo "bad configuration" > temp.txt
git add temp.txt

# Undoing the mistake: Unstage the file
git restore --staged temp.txt


# Simulating a bad commit and reverting it
echo "draft notes" > notes.txt
git add notes.txt
git commit -m "Add draft notes"
git revert HEAD

# Switch back to master and combine the feature branch
git checkout master
git merge feature/iac-setup
Branches allow you to create a "parallel universe" to build and test features without breaking the main production code. You navigate these using git checkout or git switch. When development is complete, git merge combines the feature branch back into the main project. If two engineers modify the exact same line, Git flags a Merge Conflict, requiring manual intervention to choose the correct code.
When errors inevitably happen, Git offers distinct tools for recovery. git restore is used to discard uncommitted, messy changes in the working directory. If a mistake has already been committed and pushed, git revert is the safest option; it creates a brand new commit that explicitly undoes the changes of the target commit, preserving the history. For extreme local cleanup, git reset can rewind the project to a specific point in time, though it should be used with extreme caution as it alters history.

Task 3: Working with Others (Remotes)
Steps:
Link your local project to your GitHub repository.

Push your code to the remote server.
Simulate collaborative updates.
# Connect local work to the remote GitHub server
git remote add origin https://github.com/sairam1619/aws-data-cicd.git

# Ensure the primary branch is named 'main'
git branch -M main

# Send saved commits up to the server
git push -u origin main

# Grabbing the latest changes from teammates (simulated)
git pull origin main

# Copying an existing project to a new machine
# git clone https://github.com/sairam1619/aws-data-cicd.git
Remote Repos act as the central hub (like GitHub) for your code. The git remote add command links your local folder to this server. git push is the mechanism for sending your local, committed snapshots up to GitHub, making them available to CI/CD pipelines and teammates. Conversely, git pull fetches the latest changes from the remote repository and immediately integrates them into your local files. If you need to set up your workspace on a new machine, git clone downloads the entire repository, including its full history, directly from the internet.

Task 4: Create Terraform Files and Write Your First Configuration
Steps:
Inside your project folder, create Terraform files.
touch main.tf variables.tf outputs.tf provider.tf terraform.tfvars


Open all these files in your editor.



Now we will write code in each file step by step.
Step 1: Write provider configuration (provider.tf)
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
This tells Terraform:
Use AWS and connect using your credentials.

Step 2: Define variables (variables.tf)
variable "region" {}
variable "access_key" {}
variable "secret_key" {}
variable "bucket_name" {}
This means:
We are not hardcoding values. We will pass them later.

Step 3: Provide values (terraform.tfvars)
region      = "us-east-1"
access_key  = "YOUR_ACCESS_KEY"
secret_key  = "YOUR_SECRET_KEY"
bucket_name = "sairam-terraform-demo-bucket"
Replace with your actual values.

Step 4: Create your first resource (main.tf)
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}
This creates an S3 bucket.

Step 5: Add output (outputs.tf)
output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}
This will print the bucket name after creation.

Now your Terraform basic setup is complete.







Task 5: Run Terraform Commands (First Execution)
Steps:
Initialize Terraform
terraform init

This downloads the AWS provider.

Validate code
terraform validate
Checks if syntax is correct.


Preview changes
terraform plan
Shows what Terraform will create.


Create resource
terraform apply
Type yes when asked.

Now your S3 bucket is created in AWS.


Destroy resource (for testing)
terraform destroy

Deletes everything created.

Task 6: Add More AWS Resources (Real Setup)
Steps:
Now update your main.tf with more resources.
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_dynamodb_table" "lock_table" {
  name         = "lock_table"
  billing_mode = "PAY_PER_REQUEST"

  # Primary Key
  hash_key  = "UserID"
  range_key = "OrderID"

  attribute {
    name = "UserID"
    type = "S"
  }

  attribute {
    name = "OrderID"
    type = "S"
  }

  attribute {
    name = "Email"
    type = "S"
  }

  attribute {
    name = "CreatedAt"
    type = "S"
  }

  # Global Secondary Index (uses remaining attributes)
  global_secondary_index {
    name            = "EmailIndex"
    hash_key        = "Email"
    range_key       = "CreatedAt"
    projection_type = "ALL"
  }
}

resource "aws_lambda_function" "lambda" {
  function_name = "demo_lambda"
  role          = "arn:aws:iam::854359848205:role/athena_lambda_iam"
  handler       = "index.handler"
  runtime       = "python3.14"
  filename      = "lambda.zip"
  timeout       = 850
}
Now run again:
terraform plan
terraform apply



This creates multiple resources.



Task 7: Understand Terraform State
Steps:
After running apply, you will see a file:
terraform.tfstate

This file stores:
What resources are created
Their details
Do not delete or edit this file manually.

Task 8: Setup Remote State (Very Important for CI/CD)
Steps:
Create an S3 bucket manually (for state storage).
Example:
sairam-terraform-state-bucket

Update backend.tf
terraform {
  backend "s3" {
    bucket         = "sairam-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
Run:
terraform init

Now Terraform state is stored in S3 instead of local.


Task 9: Use Locals and Data Sources
Steps:
Update main.tf
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

This automatically fetches your AWS account ID.

Task 10: Use Loops (for_each)
Steps:
Update main.tf
resource "aws_s3_bucket" "multiple" {
  for_each = toset(["dev", "qa", "prod"])

  bucket = "sairam-${each.key}-bucket"
}

This creates 3 buckets automatically.

Task 11: Add Safety (Lifecycle + Validation)
Steps:
Update main.tf
resource "aws_s3_bucket" "safe_bucket" {
  bucket = "sairam-terraform-state-bucket"
  lifecycle {
    prevent_destroy = true
  }
}
This prevents accidental deletion.

After changes in the main, we can run terraform plan and apply commands in the terminal

Task 12: Set up GitHub Actions CI/CD
Steps:
Create folder
mkdir -p .github/workflows

Create file
touch .github/workflows/terraform.yml



Add this code from your editor, I`m using Notepad++
name: Terraform CI/CD

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Init
        run: terraform init

      - name: Validate
        run: terraform validate

      - name: Plan
        run: terraform plan

      - name: Apply
        run: terraform apply -auto-approve


4. Add AWS credentials (VERY IMPORTANT)
Your workflow needs access to AWS via AWS IAM.
DO NOT hardcode keys in code
Instead:
Go to GitHub:
Open your repo
Go to Settings → Secrets and variables → Actions

Click New repository secret
Add:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION


5. Update YAML to use secrets
Modify your workflow:
     - name: Configure AWS Credentials
       uses: aws-actions/configure-aws-credentials@v2
       with:
         aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
         aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
         aws-region: ${{ secrets.AWS_REGION }}
Place this step before terraform init


6. Final Working YAML (IMPORTANT)
name: Terraform CI/CD

on:
 push:
   branches:
     - main

jobs:
 terraform:
   runs-on: ubuntu-latest

   steps:
     - name: Checkout
       uses: actions/checkout@v3

     - name: Setup Terraform
       uses: hashicorp/setup-terraform@v2

     - name: Configure AWS Credentials
       uses: aws-actions/configure-aws-credentials@v2
       with:
         aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
         aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
         aws-region: ${{ secrets.AWS_REGION }}

     - name: Init
       run: terraform init

     - name: Validate
       run: terraform validate

     - name: Plan
       run: terraform plan

     - name: Apply
       run: terraform apply -auto-approve


7. Push workflow to GitHub
git add .github/workflows/terraform.yml
git commit -m "Add Terraform CI/CD workflow"
git push origin main

8. Run CI/CD
Go to your repo on GitHub
 → Click the Actions tab
 You will see:
Terraform CI/CD → Running




9. Pull workflow from GitHub
git pull origin main
