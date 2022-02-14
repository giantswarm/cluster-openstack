{{- define "kubeadm-control-plane-template" }}
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: KubeadmControlPlaneTemplate
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
      kubeadmConfigSpec:
        clusterConfiguration:
          apiServer:
            certSANs:
              - "api.{{ include "resource.default.name" $ }}.{{ .Values.baseDomain }}"
            extraArgs:
              cloud-provider: external
              {{- if .Values.oidc.issuerUrl }}
              oidc-issuer-url: {{ .Values.issuerUrl }}
              oidc-client-id: {{ .Values.clientId }}
              oidc-username-claim: {{ .Values.usernameClaim }}
              oidc-groups-claim: {{ .Values.groupsClaim }}
              {{- if .Values.oidc.caFile }}
              oidc-ca-file: {{ .Values.caFile }}
              {{- end }}
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
        files:
          {{- include "sshFiles" . | nindent 10 }}
          {{- include "kubeProxyFiles" . | nindent 10 }}
        preKubeadmCommands:
          {{- include "kubeProxyPreKubeadmCommands" . | nindent 10 }}
        postKubeadmCommands:
          {{- include "sshPostKubeadmCommands" . | nindent 10 }}
        users:
          {{- include "sshUsers" . | nindent 10 }}
{{- end -}}
