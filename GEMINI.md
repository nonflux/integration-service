# GEMINI.md

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

## Coding Standards

- Language: Go 1.21+
- Follow existing patterns in controllers/ and pkg/
- Use controller-runtime conventions for reconcilers
- Error handling: wrap errors with `fmt.Errorf("context: %w", err)`
- Logging: use controller-runtime `log.FromContext(ctx)`
- Run `make test` before committing
- Run `make lint` for style checks

## Git Conventions

- Branch naming: `agent/<issue-number>-<short-description>`
- Commit messages: `<type>: <description>` (fix, feat, refactor, test, docs)
- Always reference issue number in PR body with `Closes #<number>`
- Sign off commits with `-s` flag

## Testing Requirements

- Unit tests required for new functions
- Use existing test helpers from `helpers/` package
- Test file naming: `*_test.go` in same package
- Controller tests use envtest (controller-runtime test framework)
- Run `make test` to execute all tests

## Security

- Never commit secrets or credentials
- Validate all external inputs
- Follow RBAC patterns — new controllers need ClusterRole entries
- No privilege escalation in RBAC rules

## Gemini Model Naming

- This project uses Google Gemini models. The latest series are Gemini 3 and 3.1
  (e.g., `gemini-3.1-pro-preview`, `gemini-3.1-flash-preview`), and newer versions
  may be released by Google over time.
- The `-preview` suffix is Google's standard naming for models accessible via API
  or Vertex AI. These are legitimate, production-ready model identifiers.
- Do NOT "fix" model names by reverting to older series (e.g., `gemini-1.5-pro`).
  Always use the model version specified in the workflow files.

## Important Files

- `PROJECT` — kubebuilder project config
- `Makefile` — build, test, lint targets
- `config/` — Kubernetes manifests, RBAC, CRDs
