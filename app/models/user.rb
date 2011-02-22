#if g = Gem.source_index.find_name('ccls-ccls_engine').last
#require 'ccls_engine'
#require g.full_gem_path + '/app/models/user'
#end
#
#User.class_eval do
#	== requires
#	*	uid (unique)
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
#class User < ActiveRecord::Base
class User < Ccls::User

	has_and_belongs_to_many :groups

#	ucb_authenticated
	document_owner

#	alias_method :may_view_calendar?, :may_read?

end
