# ECS Cluster

## Overview

This module provisions an ECS cluster used to run containerized workloads.

The cluster can host multiple services and integrates with ECS task definitions and services defined in other modules.

---

## Resources Created

* ECS Cluster
* Cluster settings
* Container Insights configuration

---

## Usage

```hcl
module "cluster" {
  source = "git::ssh://git@github.com/org/li-terraform-modules.git//modules/ecs_cluster?ref=v1.0.0"

  name = "payments-cluster"
}
```

---

## Inputs

| Name | Description               | Type        | Required |
| ---- | ------------------------- | ----------- | -------- |
| name | ECS cluster name          | string      | yes      |
| tags | Tags applied to resources | map(string) | no       |

---

## Outputs

| Name        | Description     |
| ----------- | --------------- |
| cluster_id  | ECS cluster ID  |
| cluster_arn | ECS cluster ARN |
