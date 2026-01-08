# Helm Learning Repository

Comprehensive Helm chart examples covering all major scenarios and best practices.

## Usage

```bash
# Dev
helm install myapp ./myapp -f myapp/values-dev.yaml --dry-run --debug

# Staging  
helm install myapp ./myapp -f myapp/values-staging.yaml

# Production
helm install myapp ./myapp -f myapp/values-prod.yaml
```

See README files for complete documentation.
