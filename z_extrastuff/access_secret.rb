# project_id = "YOUR-GOOGLE-CLOUD-PROJECT"  # (e.g. "my-project")
# secret_id  = "YOUR-SECRET-ID"             # (e.g. "my-secret")
# version_id = "YOUR-VERSION"               # (e.g. "5" or "latest")

# Require the Secret Manager client library.
require "google/cloud/secret_manager"

# Create a Secret Manager client.
client = Google::Cloud::SecretManager.secret_manager_service

# Build the resource name of the secret version.
name = client.secret_version_path(
  project:        project_id,
  secret:         secret_id,
  secret_version: version_id
)

# Access the secret version.
version = client.access_secret_version name: name

# Print the secret payload.
#
# WARNING: Do not print the secret in a production environment - this
# snippet is showing how to access the secret material.
payload = version.payload.data
puts "Plaintext: #{payload}"