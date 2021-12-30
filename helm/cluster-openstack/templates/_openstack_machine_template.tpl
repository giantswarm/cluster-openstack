{{- define "openstack-machine-template" -}}
- apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
  kind: OpenStackMachineTemplate
  metadata:
    labels:
      {{- include "labels.common" $ | nindent 6 }}
    name: {{ include "resource.default.name" $ }}-{{ .name }}
    namespace: {{ $.Release.Namespace }}
  spec:
    template:
      spec:
        cloudName: {{ $.Values.cloudName }}
        flavor: {{ .machineFlavor }}
        identityRef:
          name: {{ $.Values.cloudConfig }}
          kind: Secret
        image: {{ include "imageName" $ }}
        {{- if $.Values.rootVolume.enabled }}
        rootVolume:
          sourceType: image
          diskSize: {{ .diskSize }}
          sourceUUID: {{ $.Values.rootVolume.sourceUUID }}
        {{- end }}
{{- end -}}
