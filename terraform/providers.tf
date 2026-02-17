############################################
# AWS Provider
############################################

provider "aws" {
  region = var.region
}

############################################
# EKS Data Sources (Required for Auth)
############################################

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

############################################
# Kubernetes Provider (Clean Auth)
############################################

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.this.certificate_authority[0].data
  )
  token = data.aws_eks_cluster_auth.this.token
}

############################################
# Kubectl Provider (Clean Auth)
############################################

provider "kubectl" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.this.certificate_authority[0].data
  )
  token            = data.aws_eks_cluster_auth.this.token
  load_config_file = false
}

############################################
# Helm Provider (Clean Auth)
############################################

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.this.certificate_authority[0].data
    )
    token = data.aws_eks_cluster_auth.this.token
  }
}