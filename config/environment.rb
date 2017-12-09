require 'pp'
require 'json'
class Environment

	def initialize(working_dir)
		@working_dir = working_dir
	end

	def config
		@config ||= load_config_json
	end

	def working_dir
		@working_dir
	end

	private

	def load_config_json(config_file_path = File.join(working_dir, 'config.json'))
		base_conf = {
			recaptcha_secret_key: '',
			recaptcha_site_key: '',
			database: 'url_short',
			db_user: 'urlshort',
			db_pass: 'change_me',
			db_host: 'localhost',
			db_port: 5432
		}
		if File.exist?(config_file_path)
			file = File.read(config_file_path)
			file_conf = JSON.parse!(file, symbolize_names: true)
			(base_conf.keys - file_conf.keys).each { |e| file_conf[e] = base_conf[e] }
			File.open(config_file_path, 'w') { |file| file.write(JSON.pretty_generate(file_conf)) }
			file_conf
		else
			File.open(config_file_path, 'w') { |file| file.write(JSON.pretty_generate(base_conf)) }
			base_conf
		end
	end
end