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
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" . }}
giantswarm.io/cluster: {{ include "resource.default.name" . }}
giantswarm.io/organization: {{ .Values.organization }}
helm.sh/chart: {{ include "chart" . | quote }}
release.giantswarm.io/version: {{ .Values.releaseVersion }}
{{- end -}}

{{/*
Create a name stem for resource names
When resources are created from templates by Cluster API controllers, they are given random suffixes.
Given that Kubernetes allows 63 characters for resource names, the stem is truncated to 47 characters to leave
room for such suffix.
*/}}
{{- define "resource.default.name" -}}
{{- .Release.Name | replace "." "-" | trunc 47 | trimSuffix "-" -}}
{{- end -}}

{{- define "imageName" -}}
ubuntu-2004-kube-v{{ .Values.kubernetesVersion }}
{{- end -}}

{{- define "sshFiles" -}}
- path: /etc/ssh/trusted-user-ca-keys.pem
  permissions: "0600"
  # Taken from https://vault.operations.giantswarm.io/v1/ssh/public_key
  content: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4cvZ01fLmO9cJbWUj7sfF+NhECgy+Cl0bazSrZX7sU vault-ca@vault.operations.giantswarm.io"
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
