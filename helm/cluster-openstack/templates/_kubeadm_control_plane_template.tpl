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
        files:
          - path: /etc/ssh/trusted-user-ca-keys.pem
            permissions: "0600"
            # Taken from https://vault.operations.giantswarm.io/v1/ssh/public_key
            content: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4cvZ01fLmO9cJbWUj7sfF+NhECgy+Cl0bazSrZX7sU vault-ca@vault.operations.giantswarm.io"
          - path: /etc/ssh/sshd_config
            permissions: "0600"
            content: |
              # Use most defaults for sshd configuration.
              Subsystem sftp internal-sftp
              ClientAliveInterval 180
              UseDNS no
              UsePAM yes
              PrintLastLog no # handled by PAM
              PrintMotd no # handled by PAM
              # Non defaults (#100)
              ClientAliveCountMax 2
              PasswordAuthentication no
              TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem
              MaxAuthTries 5
              LoginGraceTime 60
              AllowTcpForwarding no
              AllowAgentForwarding no
        postKubeadmCommands:
          - systemctl restart sshd
        users:
          - name: giantswarm
            sudo: ALL=(ALL) NOPASSWD:ALL
      machineTemplate:
        infrastructureRef:
          apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
          kind: OpenStackMachineTemplate
          name: {{ include "resource.default.name" . }}-{{ .Values.controlPlane.class }}
      version: {{ .Values.kubernetesVersion }}
{{- end -}}
