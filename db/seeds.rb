require 'json'
require 'highline'

cli = HighLine.new
WORKING_DIR = File.expand_path('../', File.basename(__FILE__)) unless defined?(WORKING_DIR)
CONFIG_FILE = "#{WORKING_DIR}/config.json" unless defined?(CONFIG_FILE)

if File.exist?(CONFIG_FILE)
	file = File.read(CONFIG_FILE)
	config = JSON.parse!(file, symbolize_names: true)
else
	config = {
		recaptcha_secret_key: '',
		recaptcha_site_key: ''
	}

	File.open(CONFIG_FILE, 'w') { |f| f.write(JSON.pretty_generate(config)) }
end

email = cli.ask('Email Address:  ') { |q| q.validate = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
password = cli.ask('Enter your password:  ') { |q| q.echo = '*' }
add_simple_redirects = cli.agree('Add simple redirects? (ex: google to google.com, facebook to facebook.com) [Y/N] ')

if add_simple_redirects
	Url.new(source: 'google', destination: 'https://www.google.com', email: email).save
	Url.new(source: 'facebook', destination: 'https://www.facebook.com', email: email).save
	Url.new(source: 'twitter', destination: 'https://www.twitter.com', email: email).save
	Url.new(source: 'bing', destination: 'https://www.bing.com', email: email).save
	Url.new(source: 'ig', destination: 'https://www.instagram.com', email: email).save
end

if config[:recaptcha_site_key].empty? || config[:recaptcha_secret_key].empty?
	support_recaptcha = cli.agree('Do you intend to use reCAPTCHA? [Y/N] ')
else
	support_recaptcha = cli.agree('Do you want to change the reCAPTCHA API info? [Y/N] ')
end

if support_recaptcha
	config[:recaptcha_site_key] = cli.ask('What is your reCAPTCHA Site Key?:  ')
	config[:recaptcha_secret_key] = cli.ask('What is your reCAPTCHA Secret Key?:  ')
end

File.open(CONFIG_FILE, 'w') { |f| f.write(JSON.pretty_generate(config)) }
shell.say ""

account = Account.new(:email => email, :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => "admin")

if account.valid?
	account.save
	shell.say "================================================================="
	shell.say "Account has been successfully created, now you can login with:"
	shell.say "================================================================="
	shell.say "   email: #{email}"
	shell.say "   password: #{?* * password.length}"
	shell.say "================================================================="
else
	shell.say "Sorry, but something went wrong!"
	shell.say ""
	account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""
