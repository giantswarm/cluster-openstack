# cluster-openstack chart

[![CircleCI](https://circleci.com/gh/giantswarm/cluster-openstack.svg?style=shield)](https://circleci.com/gh/giantswarm/cluster-openstack)

Giant Swarm offers a Cluster OpenStack App to assist user to manage Cluster API resources in an Giant Swarm OpenStack platform.

Here we define the Cluster OpenStack App chart with its templates and default configuration.

## Installing

There are 3 ways to install this app onto a workload cluster.

1. [Using GitOps to instantiate the App](https://docs.giantswarm.io/advanced/gitops/#installing-managed-apps)
2. [Using our web interface](https://docs.giantswarm.io/ui-api/web/app-platform/#installing-an-app)
3. Directly creating the [App custom resource](https://docs.giantswarm.io/ui-api/management-api/crd/apps.application.giantswarm.io/) on the management cluster.

## Configuring

#### Cluster OpenStack App Configuration

Please see the below page for configurable values.
[Cluster OpenStack App Configuration](helm/cluster-openstack/#configuration)

See our [full reference page on how to configure applications](https://docs.giantswarm.io/app-platform/app-configuration/) for more details.

## Contact

- Mailing list: [giantswarm](https://groups.google.com/forum/!forum/giantswarm)
- Bugs: [issues](https://github.com/giantswarm/cluster-openstack/issues)

## Contributing & Reporting Bugs

See [CONTRIBUTING](CONTRIBUTING.md) for details on submitting patches, the
contribution workflow as well as reporting bugs.

For security issues, please see [the security policy](SECURITY.md).

## License

cluster-openstack is under the Apache 2.0 license. See the [LICENSE](LICENSE) file
for details.
