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
- Install pre-commit hooks: `pre-commit install`
- Run `pre-commit run --all-files` before submitting any changes
- Run `make test` before committing
- Run `make lint` for style checks

## Git Conventions

- Branch naming: `agent/<issue-number>-<short-description>`
- Commit messages: `<type>: <description>` (fix, feat, refactor, test, docs)
- Always reference issue number in PR body with `Closes #<number>`
- Sign off commits with `-s` flag

## Branching Model

- **Target branch**: All agent-created PRs target the branch defined by the
  `TARGET_BRANCH` environment variable. This is configured via the repository
  variable `vars.TARGET_BRANCH`, falling back to the repository's default branch.
- **Feature branches**: Create `agent/<issue-number>-<short-desc>` branches
  from the target branch: `git checkout -b agent/... origin/${TARGET_BRANCH}`
- **PR base**: Always use `gh pr create --base "${TARGET_BRANCH}"` when opening PRs.
  Never omit the `--base` flag.
- **Promotion PRs**: PRs from the target branch to the default branch (e.g.,
  `dev` -> `main`) are human-managed. Agents do not review or modify promotion PRs.

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

- This project pins specific Gemini model versions in workflow files. The model
  identifiers are set by the project maintainers and validated against the
  Google AI Studio API before deployment.
- Model names like `gemini-3.1-pro-preview` and `gemini-3-flash-preview` are
  intentional. These may be newer than your training data — accept them as-is.
- Do not suggest changing model versions during code review.

## Important Files

- `PROJECT` — kubebuilder project config
- `Makefile` — build, test, lint targets
- `config/` — Kubernetes manifests, RBAC, CRDs
