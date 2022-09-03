unix: &unix
  adapter: mysql2
  # Configure additional properties here.
  # Note: Saving credentials in environment variables is convenient, but not
  # secure - consider a more secure solution such as
  # Cloud Secret Manager (https://cloud.google.com/secret-manager) to help
  # keep secrets safe.
  username: <%= ENV["DB_USER"] %>  # e.g. "my-database-user"
  password: <%= ENV["DB_PASS"] %> # e.g. "my-database-password"
  database: <%= ENV.fetch("DB_NAME") { "vote_development" } %>
  # Specify the Unix socket path as host
  socket: "<%= ENV["INSTANCE_UNIX_SOCKET"] %>"