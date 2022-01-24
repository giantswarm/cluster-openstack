{{- define "cluster" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    cluster.giantswarm.io/description: {{ .Values.clusterDescription | quote }}
  labels:
    {{- include "labels.common" . | nindent 4 }}
    cluster-apps-operator.giantswarm.io/watching: ""
  name: {{ include "resource.default.name" . }}
  namespace: {{ .Release.Namespace }}
spec:
  topology:
    class: {{ include "resource.clusterClass.name" . }}
    version: {{ .Values.kubernetesVersion }}
    controlPlane:
      replicas: {{ .Values.controlPlane.replicas }}
      metadata:
        labels:
          {{- include "labels.common" . | nindent 10 }}
    workers:
      machineDeployments:
      {{- $outerScope := . }}
      {{- range .Values.nodePools }}
      {{- $innerScope := merge (deepCopy .) (deepCopy $outerScope) }}
      {{- $nodeClass := merge (dict "name" .class) (deepCopy (get $outerScope.Values.nodeClasses .class)) (deepCopy $outerScope) }}
      - class: {{ include "resource.nodeClass.name" $nodeClass }}
        name: {{ $innerScope.name }}
        replicas: {{ $innerScope.replicas }}
        metadata:
          labels:
            {{- include "labels.common" $innerScope | nindent 12 }}
            machine-deployment.giantswarm.io/failure-domain: {{ .failureDomain | quote }}
      {{- end }}
{{- end -}}
