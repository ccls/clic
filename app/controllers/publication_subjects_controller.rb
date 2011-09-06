class PublicationSubjectsController < ApplicationController
	resourceful

	before_filter :may_administrate_required, :only => :order

	def order
#		params[:publication_subjects].reverse.each { |id| Page.find(id).move_to_top }
#	this doesn't even check for parents or anything
#	making it faster, but potentially error prone.

		if params[:publication_subjects] && params[:publication_subjects].is_a?(Array)
			params[:publication_subjects].each_with_index { |id,index| 
				PublicationSubject.find(id).update_attribute(:position, index+1 ) }
		else
			flash[:error] = "No publication_subjects order given!"
		end
		redirect_to publication_subjects_path
	end

end
