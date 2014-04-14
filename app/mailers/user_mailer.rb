class UserMailer < ActionMailer::Base

	default from: "clic_centraloffice@berkeley.edu"

	def new_user_email(user,sent_at = Time.now)
		@user = user
		mail({
			:subject => 'New CLIC User',
			:to      => 'clic_centraloffice@berkeley.edu'
		})
	end

	def confirm_email(user,sent_at = Time.now)
		@user = user
		mail({
			:subject => 'CLIC Email Confirmation',
			:to      => user.email
		})
	end

	def forgot_password(user,sent_at = Time.now)
		@user = user
		mail({
			:subject => 'CLIC Password Reset',
			:to      => user.email
		})
	end

end
