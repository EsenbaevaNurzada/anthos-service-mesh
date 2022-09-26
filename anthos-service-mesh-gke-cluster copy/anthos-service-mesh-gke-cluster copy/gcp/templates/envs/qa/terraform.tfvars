gcp_project_id = "digitalcore-sandbox"

######################################
########## SERVICE ACCOUNTS ##########
######################################
service_accounts = [
  {
    account_id   = "sa-containeradmin-qa"
    account_name = "QA Container Admin"
    role         = "roles/container.admin"
  },
  {
    account_id   = "sa-firewalladmin-qa"
    account_name = "QA Firewall Admin"
    role         = "roles/compute.securityAdmin"
  },
  {
    account_id   = "sa-loadbalanceradmin-qa"
    account_name = "QA Load Balancer Admin"
    role         = "roles/compute.loadBalancerAdmin"
  },
  {
    account_id   = "sa-spanneradmin-qa"
    account_name = "QA Spanner Admin"
    role         = "roles/spanner.admin"
  },
  {
    account_id   = "sa-pubsubadmin-qa"
    account_name = "QA PubSub Admin"
    role         = "roles/pubsub.admin"
  },
  {
    account_id   = "sa-vpcadmin-qa"
    account_name = "QA Network Admin"
    role         = "roles/compute.networkAdmin"
  },
  {
    account_id   = "sa-storageadmin-poc"
    account_name = "poc Storage Admin"
    role         = "roles/storage.admin"
  },
  {
    account_id   = "sa-memcachedadmin-poc"
    account_name = "Memcached  Admin"
    role         = "roles/memcache.admin"
  }
]

######################################
############ CLOUD ARMOR #############
######################################
cloud_armor_name        = "ddoc-qa-us-east1-ca"
cloud_armor_description = "ddoc-qa-us-east1-ca"

######################################
############ GKE CLUSTER #############
######################################
gke_cluster_name = "ddoc-qa-us-east1-gke"
node_tag         = ""
location         = "us-east1-b"
port_name        = ""
subnet_name      = "qa-subnet-01"
subnet_region    = "us-east1"
#####Node pool#############
node_pools = {
  node-pool = {
    location           = "us-east1-b"
    node_locations     = ["us-east1-b"]
    machine_type       = "e2-micro"
    initial_node_count = 1
  }
}

######################################
########### LOAD BALANCER ############
######################################
backends = {
  default = {
    protocol    = "HTTP"
    port        = 80
    timeout_sec = 10
    enable_cdn  = false
    health_check = {
      request_path       = "/"
      port_specification = "USE_SERVING_PORT"
      logging            = true
    }
    log_config = {
      enable      = true
      sample_rate = 1.0
    }
    groups = [
      {
        # Each node pool instance group should be added to the backend.
        group                 = "https://www.googleapis.com/compute/v1/projects/digitalcore-sandbox/zones/us-east1-b/networkEndpointGroups/neg-qa"
        balancing_mode        = "RATE"
        max_rate_per_endpoint = "5.0"
      },
    ]
    iap_config = {
      enable               = false
      oauth2_client_id     = ""
      oauth2_client_secret = ""
    }
  }
}

lb_name               = "ddoc-qa-us-east1-lb"
lb_ssl                = true
url_map_name          = "ddoc-qa-us-east1-lb"
algorithm             = "RSA"
rsa_bits              = 2048
validity_period_hours = 12
early_renewal_hours   = 3
allowed_uses = [
  "key_encipherment",
  "digital_signature",
  "server_auth",
]
dns_names = ["example.com", "example.net"]
subject = {
  common_name  = "example.com"
  organization = "ACME Examples, Inc"
}
create_url_map = false


######################################
########## MONGO DB ATLAS ############
######################################
gcp_region                  = "us-east1"
google_compute_address_name = "ddoc-qa-us-east1"
google_compute_address_type = "INTERNAL"
google_compute_address      = "10.5.31."
cloud_provider              = "GCP"
mongo_cluster_name          = "ddoc-qa-us-east1-mongodb"
mongo_cluster_version       = "4.4"
mongo_cluster_type          = "REPLICASET"
cloud_backup                = true
autoscaling                 = true
mongo_cluster_size          = "M20"
num_shards                  = 1
mongo_cluster_region        = "EASTERN_US"
electable_nodes             = 3
priority                    = 7
read_only_nodes             = 0
subnet                      = "us-east1/qa-subnet-01"
db_username                 = "userqa"
db_password                 = "userqa"
auth_database_name          = "admin"
db_role_name                = "readWrite"
database_name               = "dbforapp"
db_key                      = "key"
db_value                    = "value"

######################################
############## PUBSUB ################
######################################
topic        = "ddoc-qa-us-east1-pubsub"
topic_labels = { team = "platform_enabler" }
schema = {
  name       = "qa-example"
  type       = "AVRO"
  encoding   = "JSON"
  definition = "{\n  \"type\" : \"record\",\n  \"name\" : \"Avro\",\n  \"fields\" : [\n    {\n      \"name\" : \"StringField\",\n      \"type\" : \"string\"\n    },\n    {\n      \"name\" : \"IntField\",\n      \"type\" : \"int\"\n    }\n  ]\n}\n"
}

push_subscriptions = [
  {
    name                    = "push-qa"
    ack_deadline_seconds    = 20
    push_endpoint           = "https://example.com"
    x-goog-version          = "v1beta1"
    audience                = "example"                     // optional
    expiration_policy       = "1209600s"                    // optional
    max_delivery_attempts   = 5                             // optional
    maximum_backoff         = "600s"                        // optional
    minimum_backoff         = "300s"                        // optional
    filter                  = "attributes.domain = \"com\"" // optional
    enable_message_ordering = true                          // optional
    # oidc_service_account_email = "sa@example.com"                                     // optional
    # dead_letter_topic          = "projects/my-pubsub-project/topics/example-dl-topic" // optional
  }
]

pull_subscriptions = [
  {
    name                    = "pull-qa"
    ack_deadline_seconds    = 20                            // optional
    max_delivery_attempts   = 5                             // optional
    maximum_backoff         = "600s"                        // optional
    minimum_backoff         = "300s"                        // optional
    filter                  = "attributes.domain = \"com\"" // optional
    enable_message_ordering = true                          // optional
    # dead_letter_topic       = "projects/my-pubsub-project/topics/example-dl-topic" // optional
    # service_account         = "service2@project2.iam.gserviceaccount.com"          // optional
  }
]

######################################
############## SPANNER ###############
######################################
instance_config = "regional-us-east1"
instance_labels = { created = "terraform" }
spanner_name    = "ddoc-qa-us-east1-spanner"
databases = [
  {
    name = "qa-db-1",
    ddl = [
      "CREATE TABLE t1 (t1 INT64 NOT NULL,) PRIMARY KEY(t1)"
    ]
  },
  {
    name = "qa-db-2",
  },
]

######################################
################ VPC #################
######################################
auto_create_subnetworks = false
network_name            = "ddoc-qa-us-east1-vpc"
routing_mode            = "GLOBAL"
shared_vpc_host         = false
delete_default_igw      = false
mtu                     = 0
description             = "Sandbox VPC"
subnets = [
  {
    subnet_name   = "qa-subnet-01"
    subnet_ip     = "10.5.0.0/19"
    subnet_region = "us-east1"
  }
]

######################################
########## Cloud Storage  ############
######################################
storage_name       = "ddoc-qa-us-central1-sta"
storage_location   = "us-central1"
storage_labels     = { created = "terraform" }
force_destroy      = false
bucket_policy_only = false
# We can add IAM member(User() along with the role that we want to give to this user on the GCP bucket

# iam_members = [{
#   role   = "roles/storage.objectAdmin"
#   member = "user:example-user@example.com"
# }]

######################################
###### Memorystore Memcached  #######
######################################
memcached_name = "ddoc-qa-us-central-mc"
node_count     = "3"