class UserMailer < ActionMailer::Base

	def confirm_email(user,sent_at = Time.now)
		subject		'Email Confirmation'
		recipients user.email
		from			 ''
		sent_on		sent_at
		body			 :greeting => 'Hi,'
		body			 :confirm_url => confirm_email_url(user.perishable_token)
	end

#	def forgot_password(sent_at = Time.now)
#		subject		'UserMailer#forgot_password'
#		recipients ''
#		from			 ''
#		sent_on		sent_at
#		body			 :greeting => 'Hi,'
#	end

end
