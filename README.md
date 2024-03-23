# Eg repo structure
├── lambdas/
│   ├── lambda1/
│   │   ├── src/
│   │   │   ├── lambda1.py
│   │   │   └── requirements.txt
│   │   └── README.md
│   │
│   ├── lambda2/
│   │   ├── src/
│   │   │   ├── lambda2.py
│   │   │   └── code.json
│   │   └── README.md
│   │
│   └── lambda3/
│       ├── src/
│       │   ├── lambda3.py
│       │   └── code.json
│       └── README.md
│
├── terraform/
│   ├──modules/
│   │   ├── lambda/
│   │   └── layers/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
└── README.md


#### lambdas/ -> lambda code
#### Terraform/ -> terraform code
