{{- define "cluster-class" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: ClusterClass
metadata:
  labels:
    {{- include "labels.common" . | nindent 4 }}
  name: {{ include "resource.clusterClass.name" . }}
  namespace: {{ .Release.Namespace }}
spec:
  controlPlane:
    ref:
      apiVersion: controlplane.cluster.x-k8s.io/v1beta1
      kind: KubeadmControlPlaneTemplate
      name: {{ include "resource.controlPlaneTemplate.name" . }}
  workers:
    machineDeployments:
    {{- $outerScope := . }}
    {{- range $className, $nodeClass := .Values.nodeClasses }}
    {{- $innerScope := merge (dict "name" $className) (deepCopy $nodeClass) (deepCopy $outerScope) }}
    - class: {{ $className }}
      template:
        bootstrap:
          ref:
            apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
            kind: KubeadmConfigTemplate
            name: {{ include "resource.kubeadmConfigTemplate.name" $innerScope }}
        infrastructure:
          ref:
            apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
            kind: OpenStackMachineTemplate
            name: {{ include "resource.workerMachineTemplate.name" $innerScope }}
    {{- end }}
  infrastructure:
    ref:
      apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
      kind: OpenStackClusterTemplate
      name: {{ include "resource.clusterTemplate.name" . }}
{{- end -}}
