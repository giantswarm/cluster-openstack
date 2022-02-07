#!/usr/bin/env bash

#
# (PK) I couldn't find a better/simpler way to conifgure it. See:
# https://github.com/kubernetes-sigs/cluster-api/issues/4512
#

set -o errexit
set -o nounset
set -o pipefail

readonly dir="/run/kubeadm"

# Run this script only if this is the init node.
if [[ ! -f ${dir}/kubeadm.yaml ]]; then
    exit 0
fi

# Exit fast if already appended.
if [[ ! -f ${dir}/gs-kube-proxy-config.yaml ]]; then
    exit 0
fi

cat ${dir}/gs-kube-proxy-config.yaml >> ${dir}/kubeadm.yaml
rm ${dir}/gs-kube-proxy-config.yaml
