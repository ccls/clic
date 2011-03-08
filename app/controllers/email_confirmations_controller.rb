class EmailConfirmationsController < ApplicationController
	skip_before_filter :login_required
	before_filter      :no_login_required
	before_filter      :valid_perishable_token_as_id_required

	def confirm
#		user = User.confirm_email(params[:id])
		@user.confirm_email
		flash[:notice] = "Email confirmed.  You may now login."
#	rescue ActiveRecord::RecordNotFound
#		flash[:error] = "User not found with that token."
#	ensure
		redirect_to login_path
	end

	def resend
#		user = User.find_using_perishable_token(params[:id])
		UserMailer.deliver_confirm_email(@user)
		flash[:notice] = "Confirmation email resent. Please check your email to complete."
		redirect_to login_path
	end

protected

	def valid_perishable_token_as_id_required
		@user = User.find_using_perishable_token(params[:id])
		unless @user
			access_denied("User not found with that token",login_path)
		end
	end

end
