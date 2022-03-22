{{- define "kubeadm-control-plane-template" }}
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: KubeadmControlPlane
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ $.Release.Namespace }}
spec:
  kubeadmConfigSpec:
    clusterConfiguration:
      apiServer:
        certSANs:
          - "api.{{ include "resource.default.name" $ }}.{{ .Values.baseDomain }}"
        extraArgs:
          cloud-provider: external
          {{- if .Values.oidc.issuerUrl }}
          {{- with .Values.oidc }}
          oidc-issuer-url: {{ .issuerUrl }}
          oidc-client-id: {{ .clientId }}
          oidc-username-claim: {{ .usernameClaim }}
          oidc-groups-claim: {{ .groupsClaim }}
          {{- if .caFile }}
          oidc-ca-file: {{ .caFile }}
          {{- end }}
          {{- end }}
          {{- end }}
      controllerManager:
        extraArgs:
          bind-address: "0.0.0.0"
          cloud-provider: external
      scheduler:
        extraArgs:
          bind-address: "0.0.0.0"
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
  machineTemplate:
    infrastructureRef:
      apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
      kind: OpenStackMachineTemplate
      name: {{ include "resource.default.name" . }}-control-plane-{{ include "osmtRevisionOfControlPlane" $ }}
  version: {{ .Values.kubernetesVersion }}
  replicas: {{ .Values.controlPlane.replicas }}
{{- end -}}
