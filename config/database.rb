require_relative 'environment'
working_dir = File.expand_path('../..', File.basename(__FILE__))
working_dir = File.expand_path('..', File.basename(__FILE__)) if defined?(Padrino)
@environment = Environment.new(working_dir)

db_connection_info = {}
db_connection_info[:base] = {
	adapter: 'postgresql',
	database: @environment.config[:database],
	username: @environment.config[:db_user],
	password: @environment.config[:db_pass],
	host: @environment.config[:db_host],
	port: @environment.config[:db_port]
}

%i[develop prod test].each do |env|
	if @environment.config.has_key?(env)
		db_connection_info[env] = {
			adapter: 'postgresql',
			database: @environment.config[env][:database],
			username: @environment.config[env][:db_user],
			password: @environment.config[env][:db_pass],
			host: @environment.config[env][:db_host],
			port: @environment.config[env][:db_port]
		}
	else
		db_connection_info[env] = db_connection_info[:base]
	end
end

ActiveRecord::Base.configurations[:development] = db_connection_info[:develop]
ActiveRecord::Base.configurations[:production] = db_connection_info[:prod]
ActiveRecord::Base.configurations[:test] = db_connection_info[:test]

# If you wish to do environment specific please define them like below
# ActiveRecord::Base.configurations[:test] = {
# 	:adapter => 'postgresql',
# 	:database => 'url_short_test',
# 	:username => 'root',
# 	:password => '',
# 	:host => 'localhost',
# 	:port => 5432
#
# }

# Setup our logger
ActiveRecord::Base.logger = logger

if ActiveRecord::VERSION::MAJOR.to_i < 4
	# Raise exception on mass assignment protection for Active Record models.
	ActiveRecord::Base.mass_assignment_sanitizer = :strict

	# Log the query plan for queries taking more than this (works
	# with SQLite, MySQL, and PostgreSQL).
	ActiveRecord::Base.auto_explain_threshold_in_seconds = 0.5
end

# Doesn't include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = false

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper
# if you're including raw JSON in an HTML page.
ActiveSupport.escape_html_entities_in_json = false

# Now we can establish connection with our db.
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Padrino.env])

# Timestamps are in the utc by default.
ActiveRecord::Base.default_timezone = :utc
