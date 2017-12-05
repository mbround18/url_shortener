# Helper methods defined here can be accessed in any controller or view in the application
require 'dry-validation'
require 'rest-client'
module UrlShort
	class App
		module BaseHelper

			def is_this_entry_valid?(url_entry)
				configure do
					def url_valid?(value)
						!  /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix.match(value).nil?
					end
				end

				schema = Dry::Validation.Schema do
					required(:source).filled(:str?)
					required(:destination).filled(:str?, :url_valid?)
					optional(:email).filled(:str?)
					required(:clicks).filled(:int?)
					required(:active).filled(:bool?)
				end

				schema.call(url_entry)
			end

			def is_this_a_human?(recaptcha_response, remote_ip)

			end

		end

		helpers BaseHelper
	end
end
