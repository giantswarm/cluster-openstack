# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).



## [Unreleased]

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


[Unreleased]: https://github.com/giantswarm/giantswarm/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/giantswarm/giantswarm/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/giantswarm/cluster-openstack/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/giantswarm/cluster-openstack/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/giantswarm/cluster-openstack/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/giantswarm/cluster-openstack/releases/tag/v0.1.0
