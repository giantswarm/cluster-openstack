#!/usr/bin/env bash

#
# Creates kube-apiserver+json.json file by replacing
# environment variables in kube-apiserver+json.tpl
#

set -o errexit
set -o nounset
set -o pipefail

cpus="$(grep -c ^processor /proc/cpuinfo)"
memory="$(awk '/MemTotal/ { printf "%d \n", $2/1024 }' /proc/meminfo)"

export MAX_REQUESTS_INFLIGHT=$((cpus*200))
export MAX_MUTATING_REQUESTS_INFLIGHT=$((cpus*100))
export API_SERVER_CPU_REQUEST=$((cpus*125))m
export API_SERVER_MEMORY_REQUEST=$((memory / 8))Mi

envsubst < "/tmp/kubeadm/patches/kube-apiserver+json.tpl"  > "/tmp/kubeadm/patches/kube-apiserver+json.json"
