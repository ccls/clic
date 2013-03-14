class UserSession < Authlogic::Session::Base

	consecutive_failed_logins_limit 50

#authlogic / lib / authlogic / session / magic_states.rb 
# won't allow login of user that is not approved? confirmed? or active?
# if those fields exist
# Our "approved" column is used for something different
	disable_magic_states true

#	find_by_login_method :find_by_anything

	validate :has_email_address_been_confirmed

private

	def has_email_address_been_confirmed
		if attempted_record
#			errors.add(:base, "You have not yet confirmed your email address."
#			errors.add(:base, ActiveRecord::Error.new(
#				self, :base, :unconfirmed_email,
#				{ :message => "You have not yet confirmed your email address." })
#				) unless attempted_record.email_confirmed?
#			errors.add(:base, "You have not yet confirmed your email address."
			errors.add(:unconfirmed_email, "You have not yet confirmed your email address."
				) unless attempted_record.email_confirmed?
		end
	end

end
