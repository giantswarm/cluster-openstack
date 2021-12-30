{{- define "cluster-class" -}}
- apiVersion: cluster.x-k8s.io/v1alpha4
  kind: ClusterClass
  metadata:
    labels:
      {{- include "labels.common" $ | nindent 6 }}
    name: {{ include "resource.default.name" $ }}
    namespace: {{ $.Release.Namespace }}
  spec:
    controlPlane:
      ref:
        apiVersion: controlplane.cluster.x-k8s.io/v1alpha4
        kind: KubeadmControlPlaneTemplate
        name: {{ include "resource.default.name" $ }}
    workers:
      machineDeployments:
      {{- range .Values.nodeClasses }}
      - class: {{ .name }}
        template:
          bootstrap:
            ref:
              apiVersion: bootstrap.cluster.x-k8s.io/v1alpha4
              kind: KubeadmConfigTemplate
              name: {{ include "resource.default.name" $ }}-{{ .name }}
          infrastructure:
            ref:
              apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
              kind: OpenStackMachineTemplate
              name: {{ include "resource.default.name" $ }}-{{ .name }}
      {{- end }}
    infrastructure:
      ref:
        apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
        kind: OpenStackClusterTemplate
        name: {{ include "resource.default.name" $ }}
{{- end -}}
