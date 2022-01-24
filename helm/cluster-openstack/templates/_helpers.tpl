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
app: {{ include "name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" . }}
giantswarm.io/cluster: {{ include "resource.default.name" . }}
giantswarm.io/organization: {{ .Values.organization }}
helm.sh/chart: {{ include "chart" . }}
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

{{- define "hash" -}}
{{- $inputs := (dict "cloudConfig" .Values.cloudConfig "cloudName" .Values.cloudName "baseDomain" .Values.baseDomain "imageName" (include "imageName" .) "externalNetworkID" .Values.externalNetworkID "rootVolume" .Values.rootVolume "nodeClasses" .Values.nodeClasses "controlPlane" (dict "machineFlavor" .Values.controlPlane.machineFlavor "diskSize" .Values.controlPlane.diskSize) "oidc" .Values.oidc) }}
{{- mustToJson $inputs | toString | quote | sha1sum | trunc 8 }}
{{- end -}}

{{- define "resource.clusterClass.name" -}}
{{ include "resource.default.name" . }}
{{- end -}}

{{- define "resource.clusterTemplate.name" -}}
{{ include "resource.default.name" . }}-{{- include "hash" . -}}
{{- end -}}

{{- define "resource.controlPlaneTemplate.name" -}}
{{ include "resource.default.name" . }}-{{- include "hash" . -}}
{{- end -}}

{{- define "resource.controlPlaneMachineTemplate.name" -}}
{{ include "resource.default.name" . }}-control-plane-{{- include "hash" . -}}
{{- end -}}

{{- define "resource.kubeadmConfigTemplate.name" -}}
{{ include "resource.default.name" . }}-worker-{{ .name }}-{{- include "hash" . -}}
{{- end -}}

{{- define "resource.workerMachineTemplate.name" -}}
{{ include "resource.default.name" . }}-worker-{{ .name }}-{{- include "hash" . -}}
{{- end -}}

{{- define "resource.nodeClass.name" -}}
{{ .name }}
{{- end -}}
