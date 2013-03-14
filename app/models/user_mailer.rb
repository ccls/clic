class UserMailer < ActionMailer::Base

	default from: "clic_centraloffice@berkeley.edu"


#
#	Really important NOTE...
#
#	These methods are usually chained ...
#
#		Notification.demo.deliver
#
#	which means that they should return a mail object.
#	Normally it does.  However, if you set a variable to be
#	used in the template, but don't call a "mail" method after
#	it, the template will NOT include this.  Surprise!
#	So make sure that the LAST thing in these methods is
#	a mail command.  I don't think it matters which.
#



#	Multiple calls to #body will overwrite the previous ones.
#	The #body method takes a hash that will be transformed
#	into instance variables for use in mail template.

	def new_user_email(user,sent_at = Time.now)
		@user = user
		mail({
			:subject => 'New CLIC User',
			:to      => 'clic_centraloffice@berkeley.edu'
		})
#		from       ''
#		mail sent_on:    sent_at
#		mail body:       ({ :user => user })
	end

	def confirm_email(user,sent_at = Time.now)
		@user = user
		mail({
			:subject => 'CLIC Email Confirmation',
			:to      => user.email
		})
#		from       ''
#		mail sent_on:    sent_at
#		mail body:       ({ :user => user })
	end

	def forgot_password(user,sent_at = Time.now)
		@user = user
		mail({
			:subject => 'CLIC Password Reset',
			:to      => user.email
		})
#		from       ''
#		mail sent_on:    sent_at
#		mail body:       ({ :user => user })
	end

end
