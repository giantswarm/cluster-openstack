{{- define "openstack-machine-template" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
kind: OpenStackMachineTemplate
metadata:
  # we should not delete existing templates during upgrades
  # since capi needs old templates to be able to rollout machines.
  finalizers:
  - cluster-api-cleaner-openstack.finalizers.giantswarm.io
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ include "osmtRevision" $ }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
      cloudName: {{ $.Values.cloudName | quote }}
      flavor: {{ .flavor | quote }}
      identityRef:
        name: {{ $.Values.cloudConfig }}
        kind: Secret
      {{- if not .Values.nodeCIDR }}
      networks:
      - filter:
          name: {{ .Values.networkName }}
        subnets:
        - filter:
            name: {{ .Values.subnetName }} 
      {{- end }}
      {{- if .bootFromVolume }}
      image: ""
      rootVolume:
        sourceType: image
        diskSize: {{ .diskSize }}
        sourceUUID: {{ .image | quote }}
      {{- else }}
      image: {{ .image | quote }}
      {{- end }}
{{- end -}}
