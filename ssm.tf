resource "aws_ssm_parameter" "vpc_endpoint" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/opensearch/${var.cluster_name}/VPC_ENDPOINT"
  description = "OpenSearch VPC Endpoint"
  type        = "String"
  value       = try(aws_elasticsearch_domain.opensearch.endpoint, "")
}

resource "aws_ssm_parameter" "cluster_endpoint" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/opensearch/${var.cluster_name}/CLUSTER_ENDPOINT"
  description = "OpenSearch Cluster Endpoint"
  type        = "String"
  value       = "https://${aws_route53_record.opensearch.fqdn}"
}

resource "aws_ssm_parameter" "kibana_endpoint" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/opensearch/${var.cluster_name}/KIBANA_ENDPOINT"
  description = "OpenSearch Kibana Endpoint"
  type        = "String"
  value       = "https://${aws_route53_record.opensearch.fqdn}/_dashboards/"
}

resource "aws_ssm_parameter" "username" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/opensearch/${var.cluster_name}/USERNAME"
  description = "OpenSearch Password"
  type        = "SecureString"
  value       = var.master_user_name
}

resource "aws_ssm_parameter" "password" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/opensearch/${var.cluster_name}/PASSWORD"
  description = "OpenSearch Password"
  type        = "SecureString"
  value       = var.master_user_password == "" ? random_string.password[0].result : var.master_user_password

  lifecycle {
    ignore_changes = [value]
  }
}
