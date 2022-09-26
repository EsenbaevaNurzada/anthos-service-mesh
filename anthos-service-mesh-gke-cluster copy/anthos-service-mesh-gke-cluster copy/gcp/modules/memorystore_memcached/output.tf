output "discovery_endpoint" {
  description = "The discovery_endpoint of the instance."
  value       = google_memcache_instance.memorystore_memcached.discovery_endpoint
}