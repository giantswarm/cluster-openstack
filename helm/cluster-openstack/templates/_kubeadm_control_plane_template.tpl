{{- define "kubeadm-control-plane-template" }}
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: KubeadmControlPlaneTemplate
metadata:
  labels:
    {{- include "labels.common" . | nindent 4 }}
  name: {{ include "resource.controlPlaneTemplate.name" . }}
  namespace: {{ .Release.Namespace }}
spec:
  template:
    spec:
      kubeadmConfigSpec:
        clusterConfiguration:
          apiServer:
            extraArgs:
              cloud-provider: external
              {{- if .Values.oidc.enabled }}
              oidc-issuer-url: https://dex.{{ include "resource.default.name" $ }}.{{ .Values.baseDomain }}
              oidc-client-id: dex-k8s-authenticator
              oidc-username-claim: email
              oidc-groups-claim: groups
              {{- end }}
          controllerManager:
            extraArgs:
              cloud-provider: external
        initConfiguration:
          nodeRegistration:
            kubeletExtraArgs:
              cloud-provider: external
            name: '{{ `{{ local_hostname }}` }}'
        joinConfiguration:
          nodeRegistration:
            kubeletExtraArgs:
              cloud-provider: external
            name: '{{ `{{ local_hostname }}` }}'
        useExperimentalRetryJoin: true
        {{- include "sshConfig" . | nindent 8 }}
      machineTemplate:
        infrastructureRef:
          apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
          kind: OpenStackMachineTemplate
          name: {{ include "resource.controlPlaneMachineTemplate.name" . }}
      version: {{ .Values.kubernetesVersion }}
{{- end -}}
