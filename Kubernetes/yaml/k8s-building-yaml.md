## Kubernetes API Resources

```bash
kubectl api-resources
```

```
NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND
bindings                                         v1                                true         Binding
componentstatuses                   cs           v1                                false        ComponentStatus
configmaps                          cm           v1                                true         ConfigMap
endpoints                           ep           v1                                true         Endpoints
events                              ev           v1                                true         Event
limitranges                         limits       v1                                true         LimitRange
namespaces                          ns           v1                                false        Namespace
nodes                               no           v1                                false        Node
persistentvolumeclaims              pvc          v1                                true         PersistentVolumeClaim
persistentvolumes                   pv           v1                                false        PersistentVolume
pods                                po           v1                                true         Pod
...
```

## Kubernetes API Versions

```bash
kubectl api-versions
```

```
admissionregistration.k8s.io/v1
apiextensions.k8s.io/v1
apiregistration.k8s.io/v1
apps/v1
authentication.k8s.io/v1
authorization.k8s.io/v1
autoscaling/v1
autoscaling/v2
batch/v1
certificates.k8s.io/v1
coordination.k8s.io/v1
discovery.k8s.io/v1
events.k8s.io/v1
flowcontrol.apiserver.k8s.io/v1
flowcontrol.apiserver.k8s.io/v1beta3
networking.k8s.io/v1
node.k8s.io/v1
policy/v1
rbac.authorization.k8s.io/v1
scheduling.k8s.io/v1
storage.k8s.io/v1
v1
```

## Explaining Service Spec

```bash
kubectl explain services.spec --recursive
```

```
KIND:       Service
VERSION:    v1

FIELD: spec <ServiceSpec>

DESCRIPTION:
    Spec defines the behavior of a service.
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
    ServiceSpec describes the attributes that a user creates on a service.
    
FIELDS:
  allocateLoadBalancerNodePorts <boolean>
  clusterIP     <string>
  clusterIPs    <[]string>
  externalIPs   <[]string>
  externalName  <string>
  externalTrafficPolicy <string>
  enum: Cluster, Local
  healthCheckNodePort   <integer>
  internalTrafficPolicy <string>
  enum: Cluster, Local
  ipFamilies    <[]string>
  ipFamilyPolicy        <string>
  enum: PreferDualStack, RequireDualStack, SingleStack
  loadBalancerClass     <string>
  loadBalancerIP        <string>
  loadBalancerSourceRanges      <[]string>
  ports <[]ServicePort>
    appProtocol <string>
    name        <string>
    nodePort    <integer>
    port        <integer> -required-
    protocol    <string>
    enum: SCTP, TCP, UDP
    targetPort  <IntOrString>
  publishNotReadyAddresses      <boolean>
  selector      <map[string]string>
  sessionAffinity       <string>
  enum: ClientIP, None
  sessionAffinityConfig <SessionAffinityConfig>
    clientIP    <ClientIPConfig>
      timeoutSeconds    <integer>
  trafficDistribution   <string>
  type  <string>
  enum: ClusterIP, ExternalName, LoadBalancer, NodePort
```

## Explaining Service Type

```bash
kubectl explain services.spec.type
```

```
KIND:       Service
VERSION:    v1

FIELD: type <string>
ENUM:
    ClusterIP
    ExternalName
    LoadBalancer
    NodePort

DESCRIPTION:
    type determines how the Service is exposed. Defaults to ClusterIP. Valid
    options are ExternalName, ClusterIP, NodePort, and LoadBalancer. "ClusterIP"
    allocates a cluster-internal IP address for load-balancing to endpoints.
    Endpoints are determined by the selector or if that is not specified, by
    manual construction of an Endpoints object or EndpointSlice objects. If
    clusterIP is "None", no virtual IP is allocated and the endpoints are
    published as a set of endpoints rather than a virtual IP. "NodePort" builds
    on ClusterIP and allocates a port on every node which routes to the same
    endpoints as the clusterIP. "LoadBalancer" builds on NodePort and creates an
    external load-balancer (if supported in the current cloud) which routes to
    the same endpoints as the clusterIP. "ExternalName" aliases this service to
    the specified externalName. Several other fields do not apply to
    ExternalName services. More info:
    https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types
    
    Possible enum values:
     - `"ClusterIP"` means a service will only be accessible inside the cluster,
    via the cluster IP.
     - `"ExternalName"` means a service consists of only a reference to an
    external name that kubedns or equivalent will return as a CNAME record, with
    no exposing or proxying of any pods involved.
     - `"LoadBalancer"` means a service will be exposed via an external load
    balancer (if the cloud provider supports it), in addition to 'NodePort'
    type.
     - `"NodePort"` means a service will be exposed on one port of every node,
    in addition to 'ClusterIP' type.
```

## Explaining NFS Server

```bash
kubectl explain deployment.spec.template.spec.volumes.nfs.server
```

```
GROUP:      apps
KIND:       Deployment
VERSION:    v1

FIELD: server <string>

DESCRIPTION:
    server is the hostname or IP address of the NFS server. More info:
    https://kubernetes.io/docs/concepts/storage/volumes#nfs
```

## Example Deployment with NFS Volume

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app-nginx
  template:
    metadata:
      labels:
        app: app-nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.17.3
          ports:
            - containerPort: 80
          volumeMounts:
            - name: nfs-volume
              mountPath: /usr/share/nginx/html
      volumes:
        - name: nfs-volume
          nfs:
            path: /data
            server: nfs.example.com
```
