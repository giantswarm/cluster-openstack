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
      cloudName: {{ .Values.cloudName | quote }}
      {{- if .Values.controlPlane.availabilityZones }}
      controlPlaneAvailabilityZones:
      {{- range .Values.controlPlane.availabilityZones }}
      - {{ . | quote }}
      {{- end }}
      {{- end }}
      identityRef:
        name: {{ .Values.cloudConfig }}
        kind: Secret
      managedAPIServerLoadBalancer: true
      managedSecurityGroups: true
      {{- if .Values.nodeCIDR }}
      nodeCidr: {{ .Values.nodeCIDR | quote }}
      {{- else }}
      network:
        name: {{ .Values.networkName }}
      subnet:
        name: {{ .Values.subnetName }}
      {{- end }}
      {{- if .Values.externalNetworkID }}
      externalNetworkId: {{ .Values.externalNetworkID | quote }}
      {{- end }}
      allowAllInClusterTraffic: true
      {{- if .Values.dnsNameservers }}
      dnsNameservers:
      {{- range .Values.dnsNameservers }}
      - {{ . | quote }}
      {{- end }}
      {{- end }}
      bastion:
        enabled: true
        instance:
          flavor: {{ .Values.bastion.flavor | quote }}
          {{- if not .Values.nodeCIDR }}
          networks:
          - filter:
              name: {{ .Values.networkName }}
            subnets:
            - filter:
                name: {{ .Values.subnetName }} 
          {{- end }}
          {{- if .Values.bastion.bootFromVolume }}
          image: ""
          rootVolume:
            sourceType: image
            diskSize: {{ .Values.bastion.diskSize }}
            sourceUUID: {{ .Values.bastion.image | quote }}
          {{- else }}
          image: {{ .Values.bastion.image | quote }}
          {{- end }}
{{- end -}}
