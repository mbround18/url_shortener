require 'pp'
UrlShort::Admin.controllers :urls do
	get :index do
		@title = "Urls"
		@urls = Url.all
		render 'urls/index'
	end

	get :new do
		@title = pat(:new_title, :model => 'url')
		@url = Url.new
		render 'urls/new'
	end

	post :create do
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

	get :edit, :with => :id do
		@title = pat(:edit_title, :model => "url #{params[:id]}")
		@url = Url.find(params[:id])
		if @url
			render 'urls/edit'
		else
			flash[:warning] = pat(:create_error, :model => 'url', :id => "#{params[:id]}")
			halt 404
		end
	end

	put :update, :with => :id do
		@title = pat(:update_title, :model => "url #{params[:id]}")
		@url = Url.find(params[:id])
		(params[:url][:active] == '0' || !params[:url][:active] ) ? params[:url][:active] = false : params[:url][:active] = true
		pp params[:url]
		if @url
			if @url.update_attributes(params[:url])
				pp @url.errors
				flash[:success] = pat(:update_success, :model => 'Url', :id => "#{params[:id]}")
				params[:save_and_continue] ?
					redirect(url(:urls, :index)) :
					redirect(url(:urls, :edit, :id => @url.id))
			else
				pp @url.errors
				flash.now[:error] = pat(:update_error, :model => 'url')
				render 'urls/edit'
			end
		else
			flash[:warning] = pat(:update_warning, :model => 'url', :id => "#{params[:id]}")
			pp @url.errors
			halt 404
		end
	end

	delete :destroy, :with => :id do
		@title = "Urls"
		url = Url.find(params[:id])
		if url
			if url.destroy
				flash[:success] = pat(:delete_success, :model => 'Url', :id => "#{params[:id]}")
			else
				flash[:error] = pat(:delete_error, :model => 'url')
			end
			redirect url(:urls, :index)
		else
			flash[:warning] = pat(:delete_warning, :model => 'url', :id => "#{params[:id]}")
			halt 404
		end
	end

	delete :destroy_many do
		@title = "Urls"
		unless params[:url_ids]
			flash[:error] = pat(:destroy_many_error, :model => 'url')
			redirect(url(:urls, :index))
		end
		ids = params[:url_ids].split(',').map(&:strip)
		urls = Url.find(ids)

		if Url.destroy urls

			flash[:success] = pat(:destroy_many_success, :model => 'Urls', :ids => "#{ids.join(', ')}")
		end
		redirect url(:urls, :index)
	end
end
