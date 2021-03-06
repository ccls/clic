class EmailConfirmationsController < ApplicationController
	skip_before_filter :login_required
	before_filter      :no_login_required
	before_filter      :valid_unexpired_perishable_token_as_id_required, :only => :confirm
	before_filter      :valid_perishable_token_as_id_required, :only => :resend

	def confirm
		@user.confirm_email
		flash[:notice] = "Email confirmed.  You may now login."
		redirect_to login_path
	end

	def resend
		@user.reset_perishable_token!
		UserMailer.confirm_email(@user).deliver
		flash[:notice] = "Confirmation email resent. Please check your email to complete."
		redirect_to login_path
	end

protected

	def valid_unexpired_perishable_token_as_id_required
		@user = User.find_using_perishable_token(params[:id])
		unless @user
			access_denied("User not found with that token.  May have expired.",login_path)
		end
	end

	def valid_perishable_token_as_id_required
		@user = User.find_by_perishable_token(params[:id])	#	does not consider expiration
		unless @user
			access_denied("User not found with that token",login_path)
		end
	end

end
