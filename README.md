# Job Application Tracker

> Serverless job tracking system built on AWS — deployed in Cape Town, running on Free Tier, costing next to nothing.

![AWS Lambda](https://img.shields.io/badge/AWS_Lambda-Python_3.12-FF9900?style=flat-square&logo=awslambda&logoColor=white)
![DynamoDB](https://img.shields.io/badge/DynamoDB-NoSQL-4053D6?style=flat-square&logo=amazondynamodb&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=flat-square&logo=terraform&logoColor=white)
![Region](https://img.shields.io/badge/Region-af--south--1-00E5A0?style=flat-square)

Built this while job hunting. Spreadsheets broke down fast — too many tabs, no status tracking, no stats. So I built proper infrastructure instead.

---

## What it does

Full CRUD REST API backed by Lambda and DynamoDB, with a frontend dashboard that shows real-time stats: total applications, interviews scheduled, offers received. Dark and light mode. Fully responsive. Deployed in `af-south-1` — Cape Town region — with zero monthly cost on Free Tier.

---

## Architecture

```
Static Frontend (HTML / CSS / JS)
         │
         ▼
API Gateway  ──  REST API
         │
         ▼
AWS Lambda  ──  Python 3.12  ──  5 functions
         │
         ▼
DynamoDB  ──  NoSQL, on-demand
```

Everything provisioned with Terraform. One `terraform apply` and it's live.

---

## Stack

| Layer | Technology |
|---|---|
| Compute | AWS Lambda (Python 3.12) |
| API | AWS API Gateway (REST) |
| Database | AWS DynamoDB |
| Frontend | HTML5, CSS3, Vanilla JS |
| Infrastructure | Terraform |
| Region | af-south-1 (Cape Town) |

---

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/applications` | Create new application |
| `GET` | `/applications` | List all applications |
| `GET` | `/applications/{id}` | Get single application |
| `PUT` | `/applications/{id}` | Update application |
| `DELETE` | `/applications/{id}` | Delete application |

---

## Deploy it yourself

**Prerequisites:** AWS account + credentials, Terraform v1.0+, Python 3.12+, AWS CLI

```bash
# 1. Clone
git clone https://github.com/Alphiosjunior/job-application-tracker.git
cd job-application-tracker

# 2. Configure AWS
aws configure
# Region: af-south-1

# 3. Package Lambda functions
cd lambda
zip -r ../terraform/lambda_functions.zip *.py
cd ..

# 4. Deploy
cd terraform
terraform init
terraform plan
terraform apply

# 5. Get your API URL
terraform output api_gateway_url
```

Then open `frontend/app.js` and set your URL:

```javascript
const API_BASE_URL = "https://YOUR_API_ID.execute-api.af-south-1.amazonaws.com/dev/applications";
```

Open `frontend/index.html` in your browser. Done.

---

## Project structure

```
job-application-tracker/
├── terraform/
│   ├── main.tf             # Provider, DynamoDB table
│   ├── lambda.tf           # Lambda functions & IAM roles
│   ├── api_gateway.tf      # API Gateway config
│   ├── variables.tf
│   └── outputs.tf
├── lambda/
│   ├── create_application.py
│   ├── list_applications.py
│   ├── get_application.py
│   ├── update_application.py
│   └── delete_application.py
├── frontend/
│   ├── index.html
│   ├── styles.css
│   └── app.js
└── README.md
```

---

## Cost

Runs entirely on AWS Free Tier.

| Service | Free allowance |
|---|---|
| Lambda | 1M requests / month |
| API Gateway | 1M requests / month (first 12 months) |
| DynamoDB | 25GB storage + 25 RCU/WCU |

Estimated cost after free tier for moderate personal use: **under $1/month.**

---

## Cleanup

```bash
cd terraform
terraform destroy
```

Tears down everything. No lingering charges.

---

---

## Author

**Alphiosjunior Iviwe Ngqele** — Computer Engineering graduate, CPUT 2025.
Building cloud infrastructure, DevOps pipelines, and AI-powered systems from Cape Town.

[GitHub](https://github.com/Alphiosjunior) · [LinkedIn](https://www.linkedin.com/in/alphiosjunior-iviwe-ngqele-8b510127a/) · [ngqeleiviwe@gmail.com](mailto:ngqeleiviwe@gmail.com)

---

MIT License
