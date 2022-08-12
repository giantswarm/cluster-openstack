# cluster-openstack

A Helm chart to deploy a Kubernetes cluster on OpenStack via CAPI / CAPO.


All credit goes to the [original authors](https://github.com/giantswarm/cluster-openstack) of this Helm chart - this is a customised and simplified (for our use-case) fork.

## Usage

Create a `values.yaml` file populated along the lines of the following:


```yaml
baseDomain: eschercloud.ai
cloudConfig: cloud-config
cloudName: escher_nick
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

oidc:
  enabled: false

controlPlane:
  availabilityZones:
    - nova
  diskSize: 20
  flavor: m1.large
  image: ubuntu-2004-kube-v1.24.2
  replicas: 1
  bootFromVolume: true

nodeClasses:
- diskSize: 30
  image: ubuntu-2004-kube-v1.24.2
  flavor: m1.large
  name: worker
  bootFromVolume: true
  diskSize: 100
- diskSize: 100
  image: ubuntu-2004-kube-v1.24.2
  flavor: vgpu.time-sliced.10gb
  name: gpu
  bootFromVolume: true
  diskSize: 100

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
