{{- define "kubeadm-control-plane-template" -}}
- apiVersion: controlplane.cluster.x-k8s.io/v1alpha4
  kind: KubeadmControlPlaneTemplate
  metadata:
    labels:
      {{- include "labels.common" $ | nindent 6 }}
    name: {{ include "resource.default.name" $ }}
    namespace: {{ $.Release.Namespace }}
  spec:
    template:
      spec:
        kubeadmConfigSpec:
          clusterConfiguration:
            apiServer:
              extraArgs:
                cloud-provider: external
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
        machineTemplate:
          infrastructureRef:
            apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
            kind: OpenStackMachineTemplate
            name: {{ include "resource.default.name" . }}-{{ .Values.controlPlane.class }}
        version: {{ .Values.kubernetesVersion }}
{{- end -}}
