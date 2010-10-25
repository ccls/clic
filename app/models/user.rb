#	== requires
#	*	uid (unique)
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
class User < ActiveRecord::Base

	has_and_belongs_to_many :groups

	ucb_authenticated
	document_owner

#	alias_method :may_view_calendar?, :may_read?

end
