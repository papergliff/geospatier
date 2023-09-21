require 'pg'
require 'yaml'

db_config = YAML.load_file(Rails.root.join('config', 'database.yml'))[Rails.env]

$pg_conn = PG.connect(
  dbname: db_config['database'],
  user: db_config['username'],
  password: db_config['password'],
  host: db_config['host'],
  port: db_config['port']
)

at_exit do
  $pg_conn.close
end
