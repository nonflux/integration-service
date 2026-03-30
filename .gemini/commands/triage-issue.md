# Triage Issue

Classify a GitHub issue and write triage results to a file.

## Steps

1. Read the pre-fetched issue content from the file path provided in the prompt
2. Read the codebase as needed to understand the issue context
3. Determine the type: `kind/bug`, `kind/feature`, `kind/enhancement`, `kind/docs`, `kind/chore`
4. Determine the area: `area/controller`, `area/api`, `area/gitops`, `area/tekton`, `area/test`
5. Determine priority: `priority/critical`, `priority/high`, `priority/medium`, `priority/low`
6. If the issue has enough detail for implementation, include `ready-for-implementation` in labels
7. Write the triage output file (path provided in the prompt) in this exact format:

```
LABELS: kind/bug,area/controller,priority/high,ready-for-implementation
---
### Triage Summary
- **Type**: kind/bug
- **Area**: area/controller
- **Priority**: priority/high
- **Ready for Implementation**: yes/no

<your detailed analysis here>
```

The first line MUST start with `LABELS:` followed by a comma-separated list.
The `---` separator MUST appear on its own line after the labels.
Everything after `---` is the triage summary in markdown.

## Constraints

- Do NOT use `gh` commands — you do not have access to the GitHub CLI
- Do NOT post comments or apply labels — a later workflow step handles that
- Do NOT modify any code files
- Do NOT create branches or PRs
- Only read files and write the triage output file
- If you cannot determine a category, use the most general option
