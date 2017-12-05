require 'pp'
require 'securerandom'
UrlShort::App.controllers :base do

	get :index, :map => '/' do
		render :index, locals: { recaptcha_site_key: '6LcObjsUAAAAAGkSH3TQdI1M0Oqh84J4ckFc4xuH' }
	end

	get :redirect, map: '/:id' do |id|
		url = Url.find_by(source: id)
		error 404 if url.nil?
		error 403 unless url[:active]
		clicks = url[:clicks]
		url.update_attribute(:clicks, clicks + 1)
		render :redirect, locals: { destination: url[:destination], clicks: clicks + 1 }
	end

	post :create, maps: '/create' do
		url = {
			source: SecureRandom.hex(4),
			destination: params[:url],
			active: true,
			clicks: 0
		}
		email = params.fetch(:email, nil)
		url[:email] = email unless email.nil?
		if is_this_entry_valid?(url)

		end
		@url = Url.new(params[:url])
		if @url.save
			@title = pat(:create_title, :model => "url #{@url.id}")
			flash[:success] = pat(:create_success, :model => 'Url')
			params[:save_and_continue] ? redirect(url(:urls, :index)) : redirect(url(:urls, :edit, :id => @url.id))
		else
			@title = pat(:create_title, :model => 'url')
			flash.now[:error] = pat(:create_error, :model => 'url')
			render 'urls/new'
		end
	end

end
