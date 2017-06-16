resource "aws_rds_cluster_instance" "hawordpress_rds_cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-hawordpress-${count.index}"
  cluster_identifier = "${aws_rds_cluster.hawordpress_rds_cluster.id}"
  instance_class     = "db.t2.small"
}

resource "aws_rds_cluster" "hawordpress_rds_cluster" {
  cluster_identifier  = "aurora-cluster-hawordpress"
  availability_zones  = ["${var.region}a", "${var.region}b", "${var.region}c"]
  master_username     = "${var.rdsuser}"
  master_password     = "${var.rdspassword}"
  final_snapshot_identifier = "some-snap"
  skip_final_snapshot = "True"
}