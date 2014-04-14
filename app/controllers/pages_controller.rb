class PagesController < ApplicationController

	before_filter :login_required, :except => :show

	before_filter :may_maintain_pages_required, 
		:except => :show

	before_filter :id_required, :only => [ :edit, :update, :destroy ]
	before_filter :page_required, :only => :show


	def order
		if params[:pages].present? && params[:pages].is_a?(Array)
			params[:pages].each_with_index { |id,index| 
				Page.find(id).update_column(:position, index+1 ) }
		else
			flash[:error] = "No page order given!"
		end
		redirect_to pages_path(:parent_id=>params[:parent_id])
	end

	def show
	end

	def all
		@page_title = "All CCLS Pages"
		@pages = Page.all
	end

	def index
		@page_title = "CCLS Pages"
		params[:parent_id] = nil if params[:parent_id].blank?
		@pages = Page.where( :parent_id => params[:parent_id] ).order(:position)
	end

	def new
		@page_title = "Create New CCLS Page"
		@page = Page.new(:parent_id => params[:parent_id])
	end

	def edit
		@page_title = "Edit CCLS Page #{@page.title(session[:locale])}"
	end

	def create
		@page = Page.new(params[:page])
		@page.save!
		flash[:notice] = 'Page was successfully created.'
		redirect_to(@page)
	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
		flash.now[:error] = "There was a problem creating the page"
		render :action => "new"
	end

	def update
		@page.update_attributes!(params[:page])
		flash[:notice] = 'Page was successfully updated.'
		redirect_to(@page)
	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
		flash.now[:error] = "There was a problem updating the page."
		render :action => "edit"
	end

	def destroy
		@page.destroy
		redirect_to(pages_path)
	end

protected

	def id_required
		if params[:id].present? and Page.exists?(params[:id])
			@page = Page.find(params[:id])
		else
			access_denied("Valid page id required!", pages_path)
		end
	end

	#	Put this in a separate before_filter so that
	#	another before_filter can access @page
	def page_required
		if params[:id].present?
			@page = Page.find(params[:id])
		else
			@page = Page.by_path("/#{[params[:path]].flatten.join('/')}")
			raise ActiveRecord::RecordNotFound if @page.nil?
		end

		@page_title = @page.title(session[:locale])
	rescue ActiveRecord::RecordNotFound
		flash_message = "Page not found with "
		flash_message << (( params[:id].blank? ) ? "path '/#{[params[:path]].flatten.join('/')}'" : "ID #{params[:id]}")

		flash.now[:error] = flash_message
	end

end
