# Explain Controller

Explain a Kubernetes controller's reconciliation logic.

## Steps

1. Read the controller file (typically in `controllers/`)
2. Identify the `Reconcile()` function
3. Trace the reconciliation flow:
   - What resource does it watch?
   - What are the reconciliation conditions?
   - What actions does it take?
   - What status does it update?
4. Identify RBAC requirements from `+kubebuilder:rbac` markers
5. Check for predicate filters in `SetupWithManager()`
6. Explain the flow in clear, structured prose

## Output Format

- **Resource**: what CRD/resource this controller manages
- **Triggers**: what events cause reconciliation
- **Flow**: step-by-step reconciliation logic
- **Dependencies**: other resources it reads/writes
- **Error handling**: how failures are handled and retried
