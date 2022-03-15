{{- define "machine-health-check" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineHealthCheck
metadata:
  labels:
    {{- include "labels.common" . | nindent 4 }}
  name: {{ include "resource.default.name" . }}
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  maxUnhealthy: 40%
  nodeStartupTimeout: 20m0s
  selector:
    matchLabels:
      cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" $ }}
  unhealthyConditions:
  - type: Ready
    status: Unknown
    timeout: 10m0s
  - type: Ready
    status: "False"
    timeout: 10m0s
{{- end -}}
