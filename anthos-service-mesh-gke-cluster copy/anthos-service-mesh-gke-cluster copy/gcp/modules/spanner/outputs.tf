output instance_id {
  description = "An identifier for the resource with format {{project}}/{{name}}"
  value = google_spanner_instance.spanner_instance.id
}

output database_names {
  description = "An identifier for the resource with format {{instance}}/{{name}}"
  value = {
    for name, db in google_spanner_database.spanner_database :
    name => db.id
  }
}
