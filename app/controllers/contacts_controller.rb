class ContactsController < ApplicationController
	before_filter :may_read_contacts_required
	def index
		@studies = Study.all
	end
end
