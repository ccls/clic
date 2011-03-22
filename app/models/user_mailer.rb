class UserMailer < ActionMailer::Base

	def new_user_email(user,sent_at = Time.now)
		subject    'New CLIC User'
		recipients 'clic_centraloffice@berkeley.edu'
		from       ''
		sent_on    sent_at
		body       :user => user
	end

	def confirm_email(user,sent_at = Time.now)
		subject    'CLIC Email Confirmation'
		recipients user.email
		from       ''
		sent_on    sent_at
		body       :greeting => 'Hi,'
		body       :confirm_url => confirm_email_url(user.perishable_token)
	end

	def forgot_password(user,sent_at = Time.now)
		subject    'CLIC Password Reset'
		recipients user.email
		from       ''
		sent_on    sent_at
		body       :greeting => 'Hi,'
#		body       :reset_url => reset_password_url(user.perishable_token)
	end

end
