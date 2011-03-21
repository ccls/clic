require 'test_helper'

class MembersOnliesControllerTest < ActionController::TestCase

	setup :create_a_membership

	assert_access_with_login(:show, { 
		:logins => [:superuser,:admin,
		  :editor,:interviewer,:reader,:active_user,
			:unapproved_group_administrator, :group_administrator,
			:group_moderator, :group_editor, :group_reader, :group_roleless,
			:unapproved_nonmember_administrator, :nonmember_administrator,
			:nonmember_editor, :nonmember_reader, :nonmember_roleless ] })
	assert_no_access_without_login :show

	assert_access_with_https   :show
	assert_no_access_with_http :show

end
