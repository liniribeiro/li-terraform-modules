# Terraform Infrastructure Modules

This repository contains reusable infrastructure modules built with Terraform.
The goal is to provide standardized building blocks for deploying services and infrastructure on AWS.

These modules are designed to promote consistency, reusability, and maintainability across environments.

---

## Architecture Goals

* Standardize infrastructure patterns
* Promote module reuse across services
* Reduce infrastructure duplication
* Improve infrastructure maintainability
* Simplify provisioning for new services

---

## Repository Structure

```
modules/
    Reusable Terraform modules

examples/
    Example infrastructure stacks using the modules

docs/
    Architecture documentation and guidelines
```

---

## Available Modules

| Module              | Description                                                     |
| ------------------- | --------------------------------------------------------------- |
| vpc                 | Creates VPC, subnets, routing, and networking infrastructure    |
| ecs_cluster         | Provisions an ECS cluster and cluster settings                  |
| ecs_service         | Creates ECS services connected to a cluster                     |
| ecs_task_definition | Defines ECS task definitions for containers                     |
| ecr_repository      | Creates an ECR repository for container images                  |
| aurora_serverless   | Provisions an Aurora Serverless database cluster                |
| naming              | Provides standard naming conventions used across infrastructure |
| constants           | Shared Terraform constants used by modules                      |

---

## Example Usage

Example of creating a basic ECS stack:

```
module "network" {
  source = "git::ssh://git@github.com/org/li-terraform-modules.git//modules/vpc?ref=v1.0.0"

  environment = "prod"
  project     = "payments"
}

module "cluster" {
  source = "git::ssh://git@github.com/org/li-terraform-modules.git//modules/ecs_cluster?ref=v1.0.0"

  name = "payments-cluster"
}

module "repository" {
  source = "git::ssh://git@github.com/org/li-terraform-modules.git//modules/ecr_repository?ref=v1.0.0"

  name = "payments-api"
}
```

---

## Versioning

This repository uses **Semantic Versioning** and automated releases through GitHub Actions.

Versions follow the format:

```
vMAJOR.MINOR.PATCH
```

Examples:

```
v1.0.0
v1.1.0
v1.1.1
```

Releases are automatically generated based on **commit messages** following the **Conventional Commits** standard. When changes are merged into the `main` branch, the CI pipeline analyzes the commit messages and determines the appropriate version bump.

### Commit Types

| Commit Type                    | Description                                          | Version Impact |
| ------------------------------ | ---------------------------------------------------- | -------------- |
| `fix:`                         | Bug fixes or small corrections                       | Patch          |
| `feat:`                        | New functionality added in a backward-compatible way | Minor          |
| `feat!:` or `BREAKING CHANGE:` | Changes that introduce breaking behavior             | Major          |
| `docs:`                        | Documentation updates                                | No release     |
| `chore:`                       | Maintenance tasks                                    | No release     |

### Examples

```
fix: correct security group rule
```

Result:

```
v1.0.1
```

```
feat: add support for private subnets in vpc module
```

Result:

```
v1.1.0
```

```
feat!: change ecs_service input variables
```

Result:

```
v2.0.0
```

### How Releases Work

1. A pull request is merged into the `main` branch.
2. GitHub Actions runs the release workflow.
3. The workflow analyzes the commit messages.
4. A new version tag is created automatically.
5. A GitHub Release is generated for the new version.

### Referencing Module Versions

Infrastructure repositories should reference a specific module version using the Git tag:

```
module "vpc" {
  source = "git::ssh://git@github.com/org/li-terraform-modules.git//modules/vpc?ref=v1.2.0"
}
```

Pinning versions ensures reproducible infrastructure deployments and prevents unexpected changes when modules are updated.

---

## Development Guidelines

When adding or modifying modules:

1. Keep modules small and focused
2. Avoid environment-specific logic
3. Document all variables and outputs
4. Follow Terraform formatting standards

Run the following before submitting changes:

```
terraform fmt
terraform validate
```

---

## Contributing

1. Create a feature branch
2. Implement the changes
3. Run Terraform formatting and validation
4. Submit a Pull Request

All infrastructure changes should be reviewed before merging.

---