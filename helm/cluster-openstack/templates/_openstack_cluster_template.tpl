{{- define "openstack-cluster-template" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
kind: OpenStackClusterTemplate
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
      {{- if .Values.managementCluster }}
      tags:
      - giant_swarm_cluster_{{ .Values.managementCluster }}_{{ include "resource.default.name" $ }}
      {{- end }}
      cloudName: {{ .Values.cloudName }}
      {{- if .Values.controlPlane.availabilityZones }}
      controlPlaneAvailabilityZones:
      {{- range .Values.controlPlane.availabilityZones }}
      - {{ . }}
      {{- end }}
      {{- end }}
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
      allowAllInClusterTraffic: true
      {{- if .Values.dnsNameservers }}
      dnsNameservers:
      {{- range .Values.dnsNameservers }}
      - {{ . }}
      {{- end }}
      {{- end }}
      bastion:
        enabled: true
        instance:
          flavor: {{ .Values.bastion.flavor }}
          image: {{ .Values.bastion.image }}
          {{- if .Values.bastion.rootVolume.sourceUUID }}
          rootVolume:
            sourceType: image
            diskSize: {{ .Values.bastion.rootVolume.diskSize }}
            sourceUUID: {{ .Values.bastion.rootVolume.sourceUUID }}
          {{- end }}
{{- end -}}
