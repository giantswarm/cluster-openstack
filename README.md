# cluster-openstack

A Helm chart to deploy a Kubernetes cluster on OpenStack via CAPI / CAPO.

All credit goes to the [original authors](https://github.com/giantswarm/cluster-openstack) of this Helm chart - this is a customised and simplified (for our use-case) fork.

Some bits also lifted from [StackHPC's Helm charts](https://github.com/stackhpc/capi-helm-charts).

## Setup and usage

Add the Helm chart repo:

```sh
helm repo add cluster-openstack https://eschercloudai.github.io/cluster-openstack/
helm repo update
```

In order for CAPI to be able to create clusters, it needs to know which API to connect to along with a set of appropriate credentials.  Craft an [OpenStack client config](https://docs.openstack.org/python-openstackclient/latest/configuration/index.html) along the lines of the following and save it as `clouds.yaml`:

```yaml
clouds:
  escher_nick:
    identity_api_version: 3
    interface: public
    region_name: RegionOne
    auth:
      domain_name: 'Default'
      project_domain_name: 'Default'
      project_name: 'nick'
      username: 'nick'
      password: 'abc123'
      auth_url: 'https://keystone:5000/v3'
```

Next, create a `values.yaml` file populated such as this example:

```yaml
baseDomain: eschercloud.ai
cloudName: escher_nick
cloudCACert: |
  -----BEGIN CERTIFICATE-----
  MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
  TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
  cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
  WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
  ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
  MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
  h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
  0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
  A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
  T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
  B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
  B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
  KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
  OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
  jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
  qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
  rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
  HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
  hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
  ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
  3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
  NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
  ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
  TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
  jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
  oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
  4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
  mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
  emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
  -----END CERTIFICATE-----
clusterDescription: test
clusterName: test
dnsNameservers:
- 1.1.1.1
- 8.8.8.8
externalNetworkID: 70bb46a1-4d43-485d-9dbc-4aa979990327
kubernetesVersion: 1.24.2
managementCluster: capi
nodeCIDR: 10.6.0.0/24
organization: escher_nick
apiServer:
  featureGates: ""
controllerManager:
  featureGates: "ExpandPersistentVolumes=true"

controlPlane:
  availabilityZones:
    - nova
  diskSize: 20
  flavor: m1.large
  image: ubuntu-2204-kube-v1.25.3
  replicas: 1
  bootFromVolume: true
  sshKeyName: "deadline-ed25519"

nodeClasses:
- name: worker
  diskSize: 30
  image: ubuntu-2204-kube-v1.25.3
  flavor: m1.large
  bootFromVolume: true
  diskSize: 100
  sshKeyName: "deadline-ed25519"
- name: gpu
  diskSize: 100
  image: ubuntu-2204-kube-v1.25.3
  flavor: vgpu.time-sliced.10gb
  bootFromVolume: true
  diskSize: 100
  sshKeyName: "deadline-ed25519"

nodePools:
- class: worker
  name: worker
  replicas: 1
  failureDomain: nova
- class: gpu
  name: gpu
  replicas: 1
  failureDomain: nova
```

Finally, create your cluster with the values defined in `values.yaml` along with our credentials in `clouds.yaml` by running the following:

```sh
helm install test-cluster -f clouds.yaml -f values.yaml cluster-openstack/cluster-openstack
```

## Additional examples

### Annotations and node labels

Annotations and node labels can be added on a per-nodepool basis.  The node labels will be applied by kubelet, so that they're set as soon as the node registers itself.  The below example includes annotations required by cluster-autoscaler for scale-from-zero support:

```
nodePools:
  - class: worker
    name: worker
    replicas: 3
    failureDomain: nova
  - class: gpu
    name: gpu
    replicas: 0
    failureDomain: nova
    annotations:
      cluster.x-k8s.io/cluster-api-autoscaler-node-group-min-size: "0"
      cluster.x-k8s.io/cluster-api-autoscaler-node-group-max-size: "50"
      capacity.cluster-autoscaler.kubernetes.io/memory: "32G"
      capacity.cluster-autoscaler.kubernetes.io/cpu: "4"
      capacity.cluster-autoscaler.kubernetes.io/gpu-type: "nvidia.com/gpu"
      capacity.cluster-autoscaler.kubernetes.io/gpu-count: "1"
    nodeLabels:
      cluster-api/accelerator: a100_MIG_1g.10Gb
  - class: gpu-large
    name: gpu-large
    replicas: 0
    failureDomain: nova
    annotations:
      cluster.x-k8s.io/cluster-api-autoscaler-node-group-min-size: "0"
      cluster.x-k8s.io/cluster-api-autoscaler-node-group-max-size: "10"
      capacity.cluster-autoscaler.kubernetes.io/memory: "192G"
      capacity.cluster-autoscaler.kubernetes.io/cpu: "24"
      capacity.cluster-autoscaler.kubernetes.io/gpu-type: "nvidia.com/gpu"
      capacity.cluster-autoscaler.kubernetes.io/gpu-count: "1"
    nodeLabels:
      cluster-api/accelerator: g.24.highmem.a100.1
```

### Node initialisation and cloud-init

It's possible to hook into the cloud-init process that's used when bootstrapping a cluster and do things like create files with a particular contents or to run arbitrary commands.  Again, this is defined on a per-nodepool basis:

```
nodePools:
  - class: worker
    name: worker
    replicas: 3
    failureDomain: nova
    sshKeyName: "deadline"
    postKubeadmCommands: |
      - "apt update"
      - "apt install -y nfs-common"
  - class: gpu
    files: |
      - path: "/etc/nvidia/gridd.conf"
        content: "ServerAddress=192.168.199.246"
    postKubeadmCommands: |
      - "apt update"
      - "apt install -y nfs-common"
    name: gpu
    replicas: 1
    failureDomain: nova
    sshKeyName: "deadline"
```

