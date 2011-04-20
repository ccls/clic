class EditorLinksController < ApplicationController

	def index
		@pages = Page.all
	end

end
