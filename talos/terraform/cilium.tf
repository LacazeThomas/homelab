resource "kubernetes_namespace" "cilium-system" {
  metadata {
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }

    name = "cilium-system"
  }
}

resource "helm_release" "cilium" {
  name = "cilium"

  repository       = "https://helm.cilium.io"
  chart            = "cilium"
  create_namespace = true
  namespace        = "cilium-system"
  version          = "1.16.3"

  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }

  set {
    name  = "kubeProxyReplacement"
    value = "true"
  }

  set {
    name  = "securityContext.capabilities.ciliumAgent"
    value = "{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}"
  }

  set {
    name  = "securityContext.capabilities.cleanCiliumState"
    value = "{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}"
  }

  set {
    name  = "cgroup.autoMount.enabled"
    value = "false"
  }

  set {
    name  = "cgroup.hostRoot"
    value = "/sys/fs/cgroup"
  }

  set {
    name  = "k8sServiceHost"
    value = "192.168.1.81"
  }

  set {
    name  = "k8sServicePort"
    value = "6443"
  }

  set {
    name  = "bpf.masquerade"
    value = "true"
  }

  set {
    name  = "operator.replicas"
    value = "1"
  }

  set {
    name  = "l2announcements.enabled"
    value = "true"
  }

  set {
    name  = "externalIPs.enabled"
    value = "true"
  }

  set {
    name  = "hubble.enabled"
    value = "false"
  }
}

resource "kubernetes_manifest" "cilium_load_balancer_ip_pool" {
  manifest = {
    apiVersion = "cilium.io/v2alpha1"
    kind       = "CiliumLoadBalancerIPPool"
    metadata = {
      name = "defaultlbpool"
    }
    spec = {
      blocks = [
        {
          start = "192.168.1.240"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "cilium_l2_announcement_policy" {
  manifest = {
    apiVersion = "cilium.io/v2alpha1"
    kind       = "CiliumL2AnnouncementPolicy"
    metadata = {
      name = "l2policy"
    }
    spec = {
      externalIPs     = true
      loadBalancerIPs = true
    }
  }
}
