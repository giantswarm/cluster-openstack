# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Removed FeatureGates that default to true in Kubernetes 1.24.
- A stanza in values file for customizing image repository of control-plane containers.
- Bump up `cluster-shared` to 0.6.4

## [0.17.1] - 2023-02-20

### Added

- Add `items` schema for `.controlPlane.availabilityZones` in `values.schema.json`.
- A stanza in values file for a list of trusted shh keys.

### Changed

- `sshFiles` helper to fetch values for trusted-user-ca-keys.pem from the values file.
- Move the existing trusted key to values.yaml.

### Deleted

- trusted-user-ca-keys.pem (to be supplied from values.yaml).

## [0.17.0] - 2022-11-07

### Changed

- Make values properties easy to overwrite in GitOps style.
- Improve the README in the project.
- Configure API priority and fairness flags based on node resources.

## [0.16.1] - 2022-09-22

### Fixed

* `kube-dns` service is not getting deleted to keep the cluster compatible to components which didn't migrated yet to `coredns` service.

## [0.16.0] - 2022-09-19

### Changed

- Move specs of immutable templates to helpers.tpl to make maintenance easier.

### Added

- Allow core-component configuration via `kubeadm --patches`
- Import the `cluster-shared` chart to apply additional `coredns` resources in a Workload Cluster via `ClusterResourceSets`

## [0.15.2] - 2022-08-17

### Fixed

- Set `requestheader-allowed-names` as `front-proxy-client` to solve authentication issues in `metrics-server`.

## [0.15.1] - 2022-08-16

### Fixed

- Add quotes for `--oidc-username-prefix` flag.

## [0.15.0] - 2022-08-16

### Added

- Allow setting `--oidc-username-prefix` in api-server flags.

## [0.14.1] - 2022-07-19

### Changed

- Remove deprecated `--insecure-port` from api-server flags.

## [0.14.0] - 2022-07-19

### Added

- Add ignition support.
- Add cert SANs for 127.0.0.1 and localhost to api-server to support Giant
  Swarm App Platform bootstrap mode.
- Allow setting etcd image repository and tag.
- Set the default etcd version to 3.5.4 (kubeadm default is 3.5.0 which is not
  recommended in production).
- Set the default etcd image to retagged Giant Swarm one.

### Changed

- Adapt control-plane configuration by comparing other providers and vintage clusters.
- Remove versioned labels from MachineSpec to prevent unnecessary rollouts.

## [0.13.0] - 2022-06-14

### Changed

- Disable bastion to fix unblock upgrades from old versions.

## [0.12.1] - 2022-06-10

### Fixed

- Fix api version upgrade issue.

## [0.12.0] - 2022-06-09

- Support for CAPO `v0.6.x` added (supports now CAPO api version `v1beta5`)

## [0.11.0] - 2022-05-23

- ⚠️ **Breaking:** Configure encryption at REST. This requires `{{ include "resource.default.name" $ }}-encryption-provider-config` secret with `encyrption` key to be present in the cluster (can be provisioned with [encryption-provider-operator](https://github.com/giantswarm/encryption-provider-operator)).

## [0.10.1] - 2022-04-13

### Fixed

- Fix `etcd` metrics url.

## [0.10.0] - 2022-04-12

### Changed

- Bind `etcd` to 0.0.0.0 to expose /metrics endpoint.

## [0.9.0] - 2022-04-04

### Changed

- Add /metrics endpoint to `--authorization-always-allow-paths` for
  `kube-controller-manager`.
- Add /metrics endpoint to `--authorization-always-allow-paths` for
  `kube-scheduler`.
- Bind `kube-controller-manager` to 0.0.0.0 to expose /metrics endpoint.
- Bind `kube-scheduler` to 0.0.0.0 to expose /metrics endpoint.

### Removed

- Remove redundant `list.yaml` after removing `ClusterClass`.

## [0.8.0] - 2022-03-22

### Changed

- Move from `giantswarm-catalog` to `cluster-catalog`.
- Add `MachineHealthCheck` for all nodes.
- Switch chart ownership to Team Rocket.

### Removed

- ⚠️ **Breaking:** Remove `ClusterClass` and refactor templates in an backward incompatible way.

## [0.7.0] - 2022-03-04

### Added

- Add OIDC flags in the configuration values for `KubeadmControlPlaneTemplate`.

## [0.6.0] - 2022-02-28

### Added

- Create separate `OpenStackMachineTemplate` for control plane machines.
- Improve documentation for values in `values.yaml`.
- Add `bootFromVolume` option on bastion, control plane, and worker machine definitions to explicitly use non-ephemeral volumes.

### Changed

- Set machine deployment `failureDomain` directly instead of using label and kyverno policy workaround (new in CAPI v1.1).
- Fix quoting of values that could be accidentally interpreted as numbers.
- Use `.Chart.Version` instead of `.Chart.AppVersion` to get correct `app.kubernetes.io/version` label on resources.
- Use new `.clusterName` value as the base name of resources instead of `.Release.Name` to keep names cleaner.
- Combine `rootVolume.sourceUUID` into `image` value.

### Removed

- Remove extraneous `release.giantswarm.io/version` label and `releaseVersion` value.
- Remove default node pools and node classes in `values.yaml` to ensure they are defined appropriately by the helm release creator.

## [0.5.0] - 2022-02-23

### Added

- Add API server `certSANs` property to generate a certificate for the API FQDN.
- Convert nodeCIDR to switch to use existing network+subnet.

### Changed

- Restrict provider to `openstack`.

## [0.4.0] - 2022-02-08

### Added

- Add optional configuration for `controlPlaneAvailabilityZones`.

## [0.3.1] - 2022-02-07

### Added

- Add kube-proxy configuration to enable metrics.

### Changed

- Allow traffic between pod and host network.

### Fixed

- Move `machineInfrastructure` ref from `KubeadmControlPlaneTemplate` to `ClusterClass`.

## [0.3.0] - 2022-01-26

### Added

- Add optional OIDC flags for the API server.

### Changed

- Push to `giantswarm-catalog` instead of `control-plane-catalog`.

### Fixed

- Add empty value for `nodeCIDR` in `values.yaml`.

## [0.2.2] - 2022-01-24

### Added

- Add bastions, SSH users and configs.

## [0.2.1] - 2022-01-21

### Removed

- Remove extraneous commit and branch labels.

## [0.2.0] - 2022-01-14

### Changed

- Update to CAPI v1beta1.

## [0.1.0] - 2022-01-05

### Added

- Initial implementation.

[Unreleased]: https://github.com/giantswarm/cluster-openstack/compare/v0.17.1...HEAD
[0.17.1]: https://github.com/giantswarm/cluster-openstack/compare/v0.17.0...v0.17.1
[0.17.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.16.1...v0.17.0
[0.16.1]: https://github.com/giantswarm/cluster-openstack/compare/v0.16.0...v0.16.1
[0.16.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.15.2...v0.16.0
[0.15.2]: https://github.com/giantswarm/cluster-openstack/compare/v0.15.1...v0.15.2
[0.15.1]: https://github.com/giantswarm/cluster-openstack/compare/v0.15.0...v0.15.1
[0.15.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.14.1...v0.15.0
[0.14.1]: https://github.com/giantswarm/cluster-openstack/compare/v0.14.0...v0.14.1
[0.14.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.13.0...v0.14.0
[0.13.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.12.1...v0.13.0
[0.12.1]: https://github.com/giantswarm/cluster-openstack/compare/v0.12.0...v0.12.1
[0.12.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.11.0...v0.12.0
[0.11.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.10.1...v0.11.0
[0.10.1]: https://github.com/giantswarm/cluster-openstack/compare/v0.10.0...v0.10.1
[0.10.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/giantswarm/cluster-openstack/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/giantswarm/cluster-openstack/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/giantswarm/cluster-openstack/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/giantswarm/cluster-openstack/releases/tag/v0.1.0
