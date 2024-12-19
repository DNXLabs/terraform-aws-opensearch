resource "aws_secretsmanager_secret" "opensearch" {
  count                   = var.secret_method == "secretsmanager" ? 1 : 0
  name                    = "/opensearch/${var.cluster_name}"
  recovery_window_in_days = 0
}

locals {
  secrets = {
    VPC_ENDPOINT     = try(aws_elasticsearch_domain.opensearch.endpoint, "")
    CLUSTER_ENDPOINT = "https://${aws_route53_record.opensearch.fqdn}"
    KIBANA_ENDPOINT  = "https://${aws_route53_record.opensearch.fqdn}/_dashboards/"
    USERNAME         = var.master_user_name
    PASSWORD         = var.master_user_password == "" ? random_string.password[0].result : var.master_user_password
  }
}

resource "aws_secretsmanager_secret_version" "opensearch" {
  count         = var.secret_method == "secretsmanager" ? 1 : 0
  secret_id     = aws_secretsmanager_secret.opensearch[0].id
  secret_string = jsonencode(local.secrets)
}
