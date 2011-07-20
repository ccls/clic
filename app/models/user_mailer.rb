class UserMailer < ActionMailer::Base

#	Multiple calls to #body will overwrite the previous ones.
#	The #body method takes a hash that will be transformed
#	into instance variables for use in mail template.

	def new_user_email(user,sent_at = Time.now)
		subject    'New CLIC User'
		recipients 'clic_centraloffice@berkeley.edu'
		from       ''
		sent_on    sent_at
		body       ({ :user => user })
	end

	def confirm_email(user,sent_at = Time.now)
		subject    'CLIC Email Confirmation'
		recipients user.email
		from       ''
		sent_on    sent_at
		body       ({ :user => user })
	end

	def forgot_password(user,sent_at = Time.now)
		subject    'CLIC Password Reset'
		recipients user.email
		from       ''
		sent_on    sent_at
		body       ({ :user => user })
	end

end
