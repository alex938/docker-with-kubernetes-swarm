# MySQL Deployment with Helm on Kubernetes

This guide will help you deploy MySQL using Helm on Kubernetes.

---

## Step 1: Add the Bitnami Helm Repository

Add the Bitnami Helm repository to your local Helm configuration:

```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo list
```

---

## Step 2: Create a Namespace for the Database

Create a namespace for the MySQL deployment:

```sh
kubectl create namespace database
```

---

## Step 3: Install MySQL Using Helm

Install MySQL in the `database` namespace:

```sh
helm install mydb --namespace database bitnami/mysql
```

---

## Step 4: Retrieve MySQL Root Credentials

Retrieve the MySQL root username and password:

```sh
echo Username: root MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace database mydb-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
```

---

## Step 5: Access the MySQL Client

Run a MySQL client pod to connect to the MySQL server:

```sh
kubectl run mydb-mysql-client --rm --tty -i --restart='Never' \
  --image docker.io/bitnami/mysql:8.4.4-debian-12-r7 \
  --namespace database --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  --command -- bash
```

Within the MySQL client pod, connect to the MySQL server:

```sh
mysql -h mydb-mysql.database.svc.cluster.local -uroot -p
```

### View mydb information

```sh
helm status --namespace database mydb
```

### Remove the install

```sh
helm list --namespace database
helm uninstall mydb --namespace database
```

### Using a values file

values.yml
```sh
auth:
  rootPassword: "test1234"
```

```sh
helm install mydb bitnami/mysql --values values.yml
```

```
kubectl get secret --namespace default mydb-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d
```