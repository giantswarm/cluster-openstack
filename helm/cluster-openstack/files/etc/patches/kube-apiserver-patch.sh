#!/usr/bin/env bash

#
# Creates kube-apiserver+json.json file by replacing
# environment variables in kube-apiserver+json.tpl
#

set -o errexit
set -o nounset
set -o pipefail
set -x

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters" >&2
    echo "Usage: bash kube-apiserver-patch.sh <resource-ratio>" >&2
    exit 1
fi

ratio=$1

cpus="$(grep -c ^processor /proc/cpuinfo)"
memory="$(awk '/MemTotal/ { printf "%d \n", $2/1024 }' /proc/meminfo)"

export MAX_REQUESTS_INFLIGHT=$((cpus*(1600/ratio)))
export MAX_MUTATING_REQUESTS_INFLIGHT=$((cpus*(800/ratio)))
export API_SERVER_CPU_REQUEST=$((cpus*(1000/ratio)))m
export API_SERVER_MEMORY_REQUEST=$((memory/ratio))Mi

envsubst < "/tmp/kubeadm/patches/kube-apiserver+json.tpl"  > "/tmp/kubeadm/patches/kube-apiserver+json.json"
