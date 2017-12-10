require 'pp'
require 'securerandom'
require 'json'
UrlShort::App.controllers :base do

	get :index, :map => '/' do
		render :index, locals: { recaptcha_site_key: environment.config[:recaptcha_site_key] }
	end

	get :redirect, map: '/:id' do |id|
		url = Url.find_by(source: id)
		error 404 if url.nil?
		if url[:active]
			clicks = url[:clicks]
			url.update_attribute(:clicks, clicks + 1)
			render :redirect, locals: { destination: url[:destination], clicks: clicks + 1 }
		else
			render 'errors/inactive_redirect'
		end
	end

	post :create, map: '/create' do
		values = JSON.parse(params.to_json, symbolize_names: true)
		url = { source: SecureRandom.hex(4), destination: values[:url], active: true, clicks: 0 }
		email = params.fetch(:email, nil)
		url[:email] = email unless email.nil? || email.empty?
		valid_entry = is_this_entry_valid?(url)
		if is_this_entry_valid?(url).first
			url[:email] = nil if email.empty?
			unless environment.config[:recaptcha_site_key] == '' || environment.config[:recaptcha_secret_key] == ''
				validity_of_humanity = is_this_a_human?(values[:'g-recaptcha-response'])
				halt 400, { status: ['Not a human!!!!!!!'] }.to_json unless validity_of_humanity[:success]
			end
			@url = Url.new(url)
			if @url.save
				response = { status: 'success', redirect: url[:source], destination: url[:destination] }.to_json
				halt 200, response
			else
				halt 400, { status: ['URL Did not save successfully!!!!!!!'] }.to_json
			end
		else
			halt 400, valid_entry.last.errors.to_json
		end

	end
end
