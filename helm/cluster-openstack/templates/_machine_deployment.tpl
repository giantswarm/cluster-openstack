{{- define "machine-deployment" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: {{ .replicas }}
  selector:
    matchLabels: null
  template:
    metadata:
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfigTemplate
          name: {{ include "resource.default.name" $ }}-{{ .class }}
      clusterName: {{ include "resource.default.name" $ }}
      failureDomain: {{ .failureDomain | quote }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
        kind: OpenStackMachineTemplate
        name: {{ include "resource.default.name" $ }}-{{ .class }}-{{ include "osmtRevisionByClass" $ }}
      version: {{ .Values.kubernetesVersion }}
{{- end -}}
