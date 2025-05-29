# Helm and Kubernetes Useful Commands

## Simulate a Helm Install or Upgrade (Dry Run)

```sh
helm install mydb bitnami/mysql --values ./values.yaml --dry-run
# or
helm upgrade mydb bitnami/mysql --values ./values.yaml --dry-run
```

## Render Templates Locally Without Installing

```sh
helm template mydb bitnami/mysql --values ./values.yaml
```

## List All Helm Releases

```sh
helm ls
```

## Get Kubernetes Secrets

```sh
kubectl get secret
```

## Get a Specific Secret in YAML Format

Replace `<name>` with the actual secret name:

```sh
kubectl get secret <name> -o yaml
```

## Get Release Notes for a Helm Release

```sh
helm get notes mydb
```

## Get Values Used in a Helm Release

```sh
helm get values mydb
```

## Get All Values (User-Supplied and Default)

```sh
helm get values mydb --all
```

## Get Values from Specific Revisions

```sh
helm get values mydb --revision 1
helm get values mydb --revision 2
```

## Get Full Manifest of a Release

```sh
helm get manifest mydb
```