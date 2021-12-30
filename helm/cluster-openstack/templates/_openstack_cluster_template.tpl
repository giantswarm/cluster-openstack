{{- define "openstack-cluster-template" -}}
- apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
  kind: OpenStackClusterTemplate
  metadata:
    labels:
      {{- include "labels.common" $ | nindent 6 }}
    name: {{ include "resource.default.name" $ }}
    namespace: {{ $.Release.Namespace }}
  spec:
    template:
      spec:
        cloudName: {{ .Values.cloudName }}
        identityRef:
          name: {{ .Values.cloudConfig }}
          kind: Secret
        managedAPIServerLoadBalancer: true
        managedSecurityGroups: true
        {{- if .Values.nodeCIDR }}
        nodeCidr: {{ .Values.nodeCIDR }}
        {{- end }}
        {{- if .Values.externalNetworkID }}
        externalNetworkId: {{ .Values.externalNetworkID }}
        {{- end }}
        {{- if .Values.dnsNameservers }}
        dnsNameservers:
        {{- range .Values.dnsNameservers }}
        - {{ . }}
        {{- end }}
        {{- end }}
{{- end -}}
