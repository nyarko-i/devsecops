# Build a VPC Network Using Terraform

## Overview

This Terraform configuration provisions a basic AWS network architecture consisting of a VPC with public and private subnets, an EC2 instance in the public subnet, and a security group controlling access to it.

## Architecture

```
AWS Account
└── VPC (10.0.0.0/16)
    ├── Public Subnet (10.0.1.0/24)
    │   ├── Internet Gateway (attached to VPC)
    │   ├── Route Table → 0.0.0.0/0 via Internet Gateway
    │   ├── Security Group (SSH:22, HTTP:80 inbound; all outbound)
    │   └── EC2 Instance (Amazon Linux 2023, t3.micro)
    └── Private Subnet (10.0.2.0/24)
        └── (no route to internet — uses VPC default route table)
```

## Requirements Met

| # | Requirement | Resource(s) |
|---|---|---|
| 1 | Create a VPC | `aws_vpc.main` |
| 2 | Create one public subnet | `aws_subnet.public`, `aws_internet_gateway.main`, `aws_route_table.public`, `aws_route_table_association.public` |
| 3 | Create one private subnet | `aws_subnet.private` |
| 4 | Create an EC2 instance in the public subnet | `aws_instance.web` |
| 5 | Create a security group for the EC2 | `aws_security_group.ec2_sg` |

## File Structure

- **main.tf** — provider configuration and all resource/data source definitions
- **variables.tf** — input variables with descriptions and defaults
- **outputs.tf** — exposes the VPC ID and the EC2 instance's public IP

## Key Design Decisions

- **AMI lookup via data source** — instead of hardcoding an AMI ID (which is region-specific and can become outdated), the `data "aws_ami" "amazon_linux"` block dynamically fetches the most recent Amazon Linux 2023 AMI at plan/apply time.
- **Private subnet has no route table association** — it intentionally falls back to the VPC's default route table, which has no internet route. This is what makes it "private": nothing needs to be added to restrict it, only something would need to be added to open it up.
- **Instance type** — the assignment originally used `t2.micro`, but AWS rejected it with `InvalidParameterCombination: not eligible for Free Tier` on this account, so it was changed to `t3.micro`.

## Usage

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

### Outputs

After `apply`, Terraform prints:
- `vpc_id` — the ID of the created VPC
- `instance_public_ip` — the public IP address of the EC2 instance

### Cleanup

```bash
terraform destroy
```

## Variables

| Name | Description | Default |
|---|---|---|
| `aws_region` | AWS region to deploy into | `eu-west-1` |
| `vpc_cidr` | CIDR block for the VPC | `10.0.0.0/16` |
| `vpc_cidr_public` | CIDR block for the public subnet | `10.0.1.0/24` |
| `vpc_cidr_private` | CIDR block for the private subnet | `10.0.2.0/24` |
| `instance_type` | EC2 instance type | `t2.micro` |

## What I Learned

- The `<TYPE>.<NAME>.<ATTRIBUTE>` reference pattern is how Terraform resources link to each other — referencing a resource without an attribute (e.g. `aws_instance.web` instead of `aws_instance.web.public_ip`) passes the whole object where a single value is expected, and fails.
- `route`, `ingress`, and `egress` are nested blocks, not arguments — they don't take `=`.
- List-typed arguments like `cidr_blocks` and `vpc_security_group_ids` require square brackets even for a single value.
- A public subnet isn't "public" just because it exists — it needs an internet gateway, a route table with a route to that gateway, and an explicit route table association. Skipping the association silently leaves the subnet on the VPC's default (non-internet) route table.
- Free Tier eligibility for instance types can vary by account/region — always check before assuming a hardcoded instance type will work.