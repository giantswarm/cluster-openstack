# cluster-openstack

A Helm chart to deploy a Kubernetes cluster on OpenStack via CAPI / CAPO.


All credit goes to the [original authors](https://github.com/giantswarm/cluster-openstack) of this Helm chart - this is a customised and simplified (for our use-case) fork.

## Setup and usage

Add the Helm chart repo:

```sh
helm repo add cluster-openstack https://eschercloudai.github.io/cluster-openstack/
helm repo update
```

Create a secret called `cloud-config` with the necessary credentials for Kubernetes to be able to talk to OpenStack.  You'll need an [OpenStack client config](https://docs.openstack.org/python-openstackclient/latest/configuration/index.html) file to reference which in this example is called `clouds.yaml`:

```
$ cat clouds.yaml
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

You might also need to include the CA certificate if your `auth_url` is secured via TLS.  With these two files, we can create the necessary secret:

```
kubectl create secret generic cloud-config \
  --from-file=clouds.yaml=./clouds.yaml \
  --from-file=cacert=/Users/nick/Downloads/isrgrootx1.pem
```

> Note that the values in the `clouds.yaml` file are read by the CAPI OpenStack provider in order to provision your cluster infrastructure.  In the below, `cloud_name` should match the name of the cloud defined in `clouds.yaml`.

Next, create a `values.yaml` file populated along the lines of the following:

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

Finally, to create your cluster with the values defined in `values.yaml` run the following:

```sh
helm install test-cluster -f values.yaml cluster-openstack/cluster-openstack
```
