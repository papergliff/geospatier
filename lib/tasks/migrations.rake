namespace :db do
  desc "Run pending migrations"
  task :migrate => :environment do
    require 'pg'
    require 'yaml'

    # Load the database configuration
    db_config = YAML.load(ERB.new(File.read(Rails.root.join('config', 'database.yml'))).result)[Rails.env]
    conn = PG.connect(
      dbname: db_config['database'],
      user: db_config['username'],
      password: db_config['password'],
      host: db_config['host'],
      port: db_config['port']
    )

    table_check = conn.exec("SELECT to_regclass('public.schema_migrations')")
    
    # Create the schema_migrations table if it doesn't exist
    unless table_check.getvalue(0,0)
      puts "Creating schema_migrations table..."
      conn.exec("CREATE TABLE schema_migrations (version VARCHAR PRIMARY KEY)")
      puts "Created schema_migrations table successfully."
    end

    # Check which migrations have already been run
    executed_migrations = conn.exec("SELECT version FROM schema_migrations").map { |row| row['version'] }

    # Load all migration files
    migration_files = Dir[Rails.root.join('db', 'migrations', '*.sql')].sort

    shared_sql_files = Dir[Rails.root.join('db', 'migrations', 'helpers', '*.sql')]
    
    shared_sql_files.each do |file|
      # puts "Loading shared SQL from #{file}..."
      shared_sql = File.read(file)
      conn.exec(shared_sql)
      # puts "Loaded shared SQL from #{file} successfully."
    end

    migration_files.each do |file|
      version = File.basename(file).split('_').first

      unless executed_migrations.include?(version)
        puts "Running migration #{file}..."

        # Execute the migration
        migration_sql = File.read(file)
        conn.exec(migration_sql)

        # Record the migration version
        conn.exec_params("INSERT INTO schema_migrations (version) VALUES ($1)", [version])
        
        puts "Migration #{file} executed successfully."
      end
    end

    conn.close
  end

  desc "Generate a new migration file"
  task :generate_migration, [:name] => :environment do |t, args|
    unless args.name
      puts "You need to specify a migration name."
      exit 1
    end

    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    migration_filename = "#{timestamp}_#{args.name}.sql"

    migration_path = Rails.root.join('db', 'migrations', migration_filename)
    
    File.open(migration_path, 'w') do |file|
      file.write("-- Your SQL goes here")
    end

    puts "Created migration: #{migration_path}"
  end

end
