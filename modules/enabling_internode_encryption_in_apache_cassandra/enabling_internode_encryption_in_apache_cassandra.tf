resource "shoreline_notebook" "enabling_internode_encryption_in_apache_cassandra" {
  name       = "enabling_internode_encryption_in_apache_cassandra"
  data       = file("${path.module}/data/enabling_internode_encryption_in_apache_cassandra.json")
  depends_on = [shoreline_action.invoke_upgrade_cassandra_version]
}

resource "shoreline_file" "upgrade_cassandra_version" {
  name             = "upgrade_cassandra_version"
  input_file       = "${path.module}/data/upgrade_cassandra_version.sh"
  md5              = filemd5("${path.module}/data/upgrade_cassandra_version.sh")
  description      = "Verify that the cluster is running a version of Apache Cassandra that supports internode encryption, and if not, upgrade to a version that does."
  destination_path = "/tmp/upgrade_cassandra_version.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_upgrade_cassandra_version" {
  name        = "invoke_upgrade_cassandra_version"
  description = "Verify that the cluster is running a version of Apache Cassandra that supports internode encryption, and if not, upgrade to a version that does."
  command     = "`chmod +x /tmp/upgrade_cassandra_version.sh && /tmp/upgrade_cassandra_version.sh`"
  params      = ["VERSION"]
  file_deps   = ["upgrade_cassandra_version"]
  enabled     = true
  depends_on  = [shoreline_file.upgrade_cassandra_version]
}

