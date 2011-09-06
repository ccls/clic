class ProfessionsController < ApplicationController
	resourceful

	before_filter :may_administrate_required, :only => :order

	def order
		if params[:professions] && params[:professions].is_a?(Array)
			params[:professions].each_with_index { |id,index| 
				Profession.find(id).update_attribute(:position, index+1 ) }
		else
			flash[:error] = "No profession order given!"
		end
		redirect_to professions_path
	end

end
