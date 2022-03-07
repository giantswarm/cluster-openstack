{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "labels.common" -}}
app: {{ include "name" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" . | quote }}
giantswarm.io/cluster: {{ include "resource.default.name" . | quote }}
giantswarm.io/organization: {{ .Values.organization | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
{{- end -}}

{{/*
Create a name stem for resource names
When resources are created from templates by Cluster API controllers, they are given random suffixes.
Given that Kubernetes allows 63 characters for resource names, the stem is truncated to 47 characters to leave
room for such suffix.
*/}}
{{- define "resource.default.name" -}}
{{ .Values.clusterName }}
{{- end -}}

{{- define "sshFiles" -}}
- path: /etc/ssh/trusted-user-ca-keys.pem
  permissions: "0600"
  # Taken from https://vault.operations.giantswarm.io/v1/ssh/public_key
  content: |
    {{- .Files.Get "files/etc/ssh/trusted-user-ca-keys.pem" | nindent 4 }}
- path: /etc/ssh/sshd_config
  permissions: "0600"
  content: |
    {{- .Files.Get "files/etc/ssh/sshd_config" | nindent 4 }}
{{- end -}}

{{- define "sshPostKubeadmCommands" -}}
- systemctl restart sshd
{{- end -}}

{{- define "sshUsers" -}}
- name: giantswarm
  sudo: ALL=(ALL) NOPASSWD:ALL
{{- end -}}

{{- define "kubeProxyFiles" }}
- path: /run/kubeadm/gs-kube-proxy-config.yaml
  permissions: "0600"
  content: |
    {{- .Files.Get "files/run/kubeadm/gs-kube-proxy-config.yaml" | nindent 4 }}
- path: /run/kubeadm/gs-kube-proxy-patch.sh
  permissions: "0700"
  content: |
    {{- .Files.Get "files/run/kubeadm/gs-kube-proxy-patch.sh" | nindent 4 }}
{{- end -}}

{{- define "kubeProxyPreKubeadmCommands" -}}
- bash /run/kubeadm/gs-kube-proxy-patch.sh
{{- end -}}
