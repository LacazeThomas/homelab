terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
  }
}

provider "argocd" {
  use_local_config = true
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
