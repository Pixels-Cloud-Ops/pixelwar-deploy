# ── INDUS ─────────────────────────────────────────────────────────────────────
resource "aws_eip" "indus_master_eip" {
  instance = aws_instance.indus_master.id
  domain   = "vpc"
  tags     = { Name = "indus-master-eip" }
}

resource "aws_eip" "indus_worker_eip" {
  instance = aws_instance.indus_worker.id
  domain   = "vpc"
  tags     = { Name = "indus-worker-eip" }
}

# ── PROD ──────────────────────────────────────────────────────────────────────
resource "aws_eip" "prod_master_eip" {
  instance = aws_instance.prod_master.id
  domain   = "vpc"
  tags     = { Name = "prod-master-eip" }
}

resource "aws_eip" "prod_worker_eip" {
  count    = 2
  instance = aws_instance.prod_worker[count.index].id
  domain   = "vpc"
  tags     = { Name = "prod-worker-eip-${count.index + 1}" }
}

# ── OUTPUTS ───────────────────────────────────────────────────────────────────
output "indus_master_ip" {
  value = aws_eip.indus_master_eip.public_ip
}

output "indus_worker_ip" {
  value = aws_eip.indus_worker_eip.public_ip
}

output "prod_master_ip" {
  value = aws_eip.prod_master_eip.public_ip
}

output "prod_worker_ips" {
  value = aws_eip.prod_worker_eip[*].public_ip
}