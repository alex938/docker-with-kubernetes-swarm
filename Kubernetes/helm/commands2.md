# Helm and Kubernetes Useful Commands

## Simulate Helm Install or Upgrade (Dry Run)

```sh
helm install mydb bitnami/mysql --values ./values.yaml --dry-run
helm upgrade mydb bitnami/mysql --values ./values.yaml --dry-run
```

## Render Manifests Locally

```sh
helm template mydb bitnami/mysql --values ./values.yaml
```

## List All Releases

```sh
helm ls
```

## Get Kubernetes Secrets

```sh
kubectl get secret
kubectl get secret <name> -o yaml   # Replace <name> with actual secret name
```

---

## Helm Release Information

```sh
helm get notes mydb              # Show release notes
helm get values mydb             # Show values
helm get values mydb --all       # Show all values (default + user-defined)
helm get values mydb --revision 1
helm get values mydb --revision 2
helm get manifest mydb           # Show full manifest
```

---

## View History and Rollback

```sh
helm history mydb                # Shows history (includes errors)
helm rollback mydb 1             # Rollback to revision 1
```

---

## Install into a Specific Namespace (Create if Needed)

```sh
helm install web bitnami/apache \
  --namespace mynamespace \
  --create-namespace
```

## Upgrade a Release (Install if Missing)

```sh
helm upgrade --install web bitnami/apache
```

## Install with a Generated Name

```sh
helm install bitnami/apache --generate-name
helm ls
```

## Name Templating for Generated Names

```sh
helm install bitnami/apache \
  --generate-name \
  --name-template "web-{{randAlpha 7 | lower}}"
```

## Wait for Completion with Timeout

```sh
helm install web bitnami/apache \
  --wait \
  --timeout 5m10s   # Example with timeout
```

### Another Timeout Example

```sh
helm install web bitnami/apache \
  --timeout 7m12s   # Default is 5 minutes
```

## Atomic Install (Rollback on Failure)

```sh
helm install web bitnami/apache --atomic
```

## Force Install (Force Resource Updates)

```sh
helm upgrade --install web bitnami/apache --force
```

## Cleanup Failed Release on Failure

```sh
helm install web bitnami/apache --cleanup-on-failure
```