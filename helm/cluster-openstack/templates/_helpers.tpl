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

{{- define "sshConfig" -}}
files:
  - path: /etc/ssh/trusted-user-ca-keys.pem
    permissions: "0600"
    # Taken from https://vault.operations.giantswarm.io/v1/ssh/public_key
    content: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4cvZ01fLmO9cJbWUj7sfF+NhECgy+Cl0bazSrZX7sU vault-ca@vault.operations.giantswarm.io"
  - path: /etc/ssh/sshd_config
    permissions: "0600"
    content: |
      # Use most defaults for sshd configuration.
      Subsystem sftp internal-sftp
      ClientAliveInterval 180
      UseDNS no
      UsePAM yes
      PrintLastLog no # handled by PAM
      PrintMotd no # handled by PAM
      # Non defaults (#100)
      ClientAliveCountMax 2
      PasswordAuthentication no
      TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem
      MaxAuthTries 5
      LoginGraceTime 60
      AllowTcpForwarding no
      AllowAgentForwarding no
postKubeadmCommands:
  - systemctl restart sshd
users:
  - name: giantswarm
    sudo: ALL=(ALL) NOPASSWD:ALL
{{- end -}}
