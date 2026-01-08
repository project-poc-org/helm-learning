# Helm Learning Repository

Master Helm with comprehensive examples covering ALL features.

## Structure
```
myapp/
├── Chart.yaml                  # Chart metadata
├── values.yaml                 # Default values (base)
├── values-dev.yaml            # Dev overrides
├── values-staging.yaml        # Staging overrides
├── values-prod.yaml           # Production overrides
└── templates/
    ├── _helpers.tpl           # Named templates & functions
    ├── deployment.yaml        # All conditionals & loops
    ├── service.yaml           # Service with conditions
    ├── ingress.yaml           # Multiple hosts
    ├── configmap.yaml         # Loops over maps
    ├── secret.yaml            # Conditionals
    ├── hpa.yaml               # With conditions
    ├── pvc.yaml               # Persistence
    ├── serviceaccount.yaml    # RBAC
    ├── networkpolicy.yaml     # Security
    └── pdb.yaml               # PodDisruptionBudget
```

## Helm Features Covered

### 1. Template Functions & Pipelines
```yaml
{{ .Values.name | default "myapp" | quote }}
{{ .Values.name | upper }}
{{ include "myapp.fullname" . }}
```

### 2. Conditionals
```yaml
{{- if .Values.ingress.enabled }}
# ingress manifest
{{- else if .Values.service.type "LoadBalancer" }}
# loadbalancer
{{- else }}
# default
{{- end }}
```

### 3. Loops
```yaml
{{- range .Values.envVars }}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end }}
```

### 4. Variables
```yaml
{{- $fullname := include "myapp.fullname" . -}}
{{- $labels := include "myapp.labels" . -}}
```

### 5. With (scoping)
```yaml
{{- with .Values.persistence }}
  storageClass: {{ .storageClass }}
{{- end }}
```

## Usage

```bash
# Dry run to see output
helm install myapp ./myapp -f myapp/values-dev.yaml --dry-run --debug

# Template only (no cluster connection)
helm template myapp ./myapp -f myapp/values-dev.yaml

# Install dev
helm install myapp ./myapp -f myapp/values-dev.yaml

# Upgrade
helm upgrade myapp ./myapp -f myapp/values-prod.yaml

# Override specific values
helm install myapp ./myapp --set replicaCount=5 --set image.tag=v2.0.0
```

## Learning Path
1. Read `values.yaml` - understand structure
2. Study `_helpers.tpl` - named templates
3. Analyze `deployment.yaml` - all features in one file
4. Test: `helm template myapp ./myapp -f myapp/values-dev.yaml > output.yaml`
5. Compare output across environments
