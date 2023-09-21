require 'pg'
require 'yaml'
require 'erb'

db_config = YAML.load(ERB.new(File.read(Rails.root.join('config', 'database.yml'))).result)[Rails.env]

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
