# Helper methods defined here can be accessed in any controller or view in the application
require 'pp'
require 'dry-validation'
require 'rest-client'
require_relative '../../config/environment'
WORKING_DIR = Padrino.root unless defined?(WORKING_DIR)
DRY_VALIDATION_ERRORS_FILE = File.join(WORKING_DIR, 'config', 'errors', 'dry_validations_errors.yaml') unless defined?(DRY_VALIDATION_ERRORS_FILE)
module UrlShort
	class App
		module BaseHelper

			def environment
				@environment ||= Environment.new(Padrino.root)
			end

			def is_this_entry_valid?(url_entry)


				schema = Dry::Validation.Schema do
					configure do
						config.messages_file = DRY_VALIDATION_ERRORS_FILE

						def url_valid?(value)
							!  /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix.match(value).nil?
						end

						def valid_email?(value)
							!   /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ix.match(value).nil?
						end
					end

					required(:source).filled(:str?)
					required(:destination).filled(:str?, :url_valid?)
					optional(:email).filled(:str?, :valid_email?)
					required(:clicks).filled(:int?)
					required(:active).filled(:bool?)
				end

				validity = schema.call(url_entry)
				[validity.errors.empty?, validity]
			end

			def is_this_a_human?(response)
				rest_response = RestClient.post 'https://www.google.com/recaptcha/api/siteverify', {secret: environment.config[:recaptcha_secret_key], response: response}
				JSON.parse!(rest_response, symbolize_names: true)
			end

		end

		helpers BaseHelper
	end
end
