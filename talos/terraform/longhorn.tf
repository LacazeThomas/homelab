resource "kubernetes_namespace" "longhorn-system" {
  metadata {
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }

    name = "longhorn-system"
  }
}

resource "argocd_application" "helm" {
  metadata {
    name      = "longhorn"
    namespace = "argocd"
  }

  spec {

    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "longhorn-system"
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

      sync_options = ["Validate=false"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }

    source {
      repo_url        = "https://charts.longhorn.io"
      chart           = "longhorn"
      target_revision = "1.7.2"
      helm {
        release_name = "longhorn"
      }
    }
  }
}
