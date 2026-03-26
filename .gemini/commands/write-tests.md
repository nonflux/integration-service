# Write Tests

Generate tests for a specified file or function.

## Steps

1. Read the target file to understand its behavior
2. Identify existing test patterns in `*_test.go` files nearby
3. Write tests covering:
   - Happy path (expected inputs → expected outputs)
   - Error cases (invalid inputs, missing resources)
   - Edge cases (empty inputs, nil values, boundary conditions)
4. Use existing test helpers from `helpers/` package
5. For controller tests, use envtest framework
6. Run `make test` to verify tests pass

## Constraints

- Follow existing test patterns in the codebase
- Use table-driven tests where appropriate
- Do not mock what you can test with envtest
- Test file must be in the same package as the code under test
