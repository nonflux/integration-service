# AGENTS.md

Instructions for AI agents working on this repository.

## Project Overview

integration-service is a Kubernetes controller that manages integration testing
in Konflux. It watches for Snapshot resources and creates IntegrationTestScenario
runs to validate component builds before promotion.

## Architecture

- `cmd/` — main entrypoint
- `controllers/` — Kubernetes controllers (reconcilers)
- `api/` — API types and CRDs
- `pkg/` — shared packages
- `gitops/` — GitOps integration
- `tekton/` — Tekton pipeline integration
- `helpers/` — test helpers and utilities

## Build and Test

- Run `make test` before committing — all tests must pass
- Run `make vet` for Go static analysis — fix any failures before committing
- Run `pre-commit run --files <changed-files>` for style checks if pre-commit is available
- Run `make build` to verify compilation

## Coding Standards

- Language: Go 1.21+
- Follow existing patterns in `controllers/` and `pkg/`
- Use controller-runtime conventions for reconcilers
- Error handling: wrap errors with `fmt.Errorf("context: %w", err)`
- Logging: use controller-runtime `log.FromContext(ctx)`

## Git Conventions

- Commit messages: `<type>: <description>` (fix, feat, refactor, test, docs)
- Reference issue number in PR body with `Closes #<number>`
- Sign off commits with `-s` flag

## Testing Requirements

- Unit tests required for new functions
- Use existing test helpers from `helpers/` package
- Test file naming: `*_test.go` in same package
- Controller tests use envtest (controller-runtime test framework)

## Security

- Never commit secrets or credentials
- Validate all external inputs
- Follow RBAC patterns — new controllers need ClusterRole entries
- No privilege escalation in RBAC rules

## Restrictions

- Do not modify `.github/workflows/`, `.github/CODEOWNERS`, or CI configuration without explicit approval
- Do not add new dependencies without justification
- Do not change API types in `api/` without considering backwards compatibility
