require 'test_helper'

class UserTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:username)
	assert_should_require_unique(:username)
	assert_should_require(:first_name)
	assert_should_require(:last_name)
	assert_should_require(:degrees)
	assert_should_require(:title)
	assert_should_not_require(:profession)
	assert_should_require(:organization)
	assert_should_require(:address)
	assert_should_require(:phone_number)
	assert_should_require(:profession_ids)
	assert_should_not_require(:research_interests)
	assert_should_not_require(:selected_publications)
#	can't test this way as initially has one and fails assertion
#	assert_should_have_many(:user_professions)
	assert_should_have_many(:memberships)
#	assert_should_have_many(:announcements)
	assert_should_have_many(:announcements)
	assert_should_have_many(:topics)
	assert_should_have_many(:posts)
#	polymorphism causing an issue here I think
#	assert_should_have_many(:documents, :as => :owner)
	assert_should_have_many(:group_documents)
	assert_should_protect(:approved)
	assert_should_habtm(:roles)

	test "perishable_token should have 12 hour expiration" do
		assert_equal User.perishable_token_valid_for, 12.hours.to_i
	end

	test "should return username as to_s" do
		object = create_object
		assert_equal object.username, "#{object}"
	end

	test "should find by username with ['string']" do
		new_object = create_object
		object = User[new_object.username]
		assert object.is_a?(User)
	end

	test "should find by username with [:symbol]" do
		new_object = create_object
		object = User[new_object.username.to_sym]
		assert object.is_a?(User)
	end

	test "should accept attributes for membership requests" do
		assert_difference("Membership.count", 1){
		assert_difference("User.count", 1){
			@new_object = FactoryGirl.create(:user,{
				:membership_requests => { 
					Group.joinable.first.id.to_s => {
						:group_role_id => GroupRole['editor'].id }
				} 
			})
		} }
	end

	test "should NOT create approved memberships" do
		assert_difference("Membership.count", 1){
		assert_difference("User.count", 1){
			@new_object = FactoryGirl.create(:user,{
				:membership_requests => { 
					Group.joinable.first.id.to_s => {
						:group_role_id => GroupRole['editor'].id,
						:approved => true }
				} 
			})
		} }
		assert !@new_object.memberships.first.approved?
	end

	test "should NOT create duplicate membership for duplicate groups" do
		#	Primarily because its a hash and the second key overwrites the first
		assert_difference("Membership.count", 1){
		assert_difference("User.count", 1){
			@new_object = FactoryGirl.create(:user,{
				:membership_requests => { 
					Group.joinable.first.id.to_s => {
						:group_role_id => GroupRole['editor'].id },
					Group.joinable.first.id.to_s => {
						:group_role_id => GroupRole['reader'].id }
				} 
			})
		} }
		#	As hashes are not sorted, I don't know how true the following
		#	actually is.  Always?  Sometimes?  It passes now.
		assert_equal @new_object.memberships.first.group_role, GroupRole['reader']
	end

	test "should NOT create memberships for requests without a role" do
		assert_difference("Membership.count", 0){
		assert_difference("User.count", 1){
			@new_object = FactoryGirl.create(:user,{
				:membership_requests => { 
					Group.joinable.first.id.to_s => {
						:group_role_id => '' }
				} 
			})
		} }
	end

	test "should be unapproved after create" do
		assert_difference("User.count",1) do
			@user = FactoryGirl.create(:user)
		end
		assert !@user.reload.approved?
	end

	test "should be approved after assigned role" do
		assert_difference("User.count",1) do
			@user = FactoryGirl.create(:user)
		end
		assert !@user.reload.approved?
		assert_difference("User.find(#{@user.id}).roles.length",1) do
			@user.roles << Role.find_or_create_by_name('editor')
		end
		assert @user.reload.approved?
	end

	test "should be approved after membership approved" do
		assert_difference("User.count",1) do
			@user = FactoryGirl.create(:user)
		end
		assert !@user.reload.approved?
		deny_changes("User.find(#{@user.id}).perishable_token") {
			assert_difference("User.find(#{@user.id}).memberships.length",1) {
			assert_difference("Membership.count",1) {
				@m = FactoryGirl.create(:membership, :user => @user)
			} }
			assert_equal @user, @m.user
			assert !@m.reload.approved?
			@m.approve!
			assert @m.reload.approved?
			assert @user.reload.approved?
		}
	end

	test "should cleanup attachment file name" do
		bad_file_name = File.join(Rails.root, 'test', 'assets', %Q{IT's, 1234 UPPERCASE!.PNG})
		document = File.open(bad_file_name,'rb')
		record = User.new(:avatar => document)
		assert_equal "ITs_1234_UPPERCASE_.PNG", record.avatar_file_name
		document.close
	end

#end
#__END__


	test "should create user" do
		assert_difference 'User.count' do
			user = create_object
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
			assert !user.may_administrate?
		end
	end

	test "should create reader" do
		assert_difference 'User.count' do
			user = create_object
			user.roles << Role.find_by_name('reader')
			assert  user.is_reader?
			assert  user.may_read?
			assert !user.is_administrator?
			assert !user.may_administrate?
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create interviewer" do
		assert_difference 'User.count' do
			user = create_object
			user.roles << Role.find_by_name('interviewer')
			assert  user.is_interviewer?
			assert  user.may_interview?
			assert  user.may_read?
			assert !user.is_administrator?
			assert !user.may_administrate?
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create editor" do
		assert_difference 'User.count' do
			user = create_object
			user.roles << Role.find_by_name('editor')
			assert  user.is_editor?
			assert  user.may_edit?
			assert  user.may_interview?
			assert  user.may_read?
			assert !user.is_administrator?
			assert !user.may_administrate?
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create administrator" do
		assert_difference 'User.count' do
			user = create_object
			user.roles << Role.find_by_name('administrator')
			assert  user.is_administrator?
			assert  user.may_edit?
			assert  user.may_interview?
			assert  user.may_read?
			assert  user.may_administrate?

			assert user.may_view_permissions?
			assert user.may_create_user_invitations?
			assert user.may_view_users?
			assert user.may_assign_roles?
			assert user.may_maintain_pages?
			assert user.may_view_user?
			assert user.is_user?(user)
			assert user.may_be_user?(user)
			assert user.may_share_document?('document')
			assert user.may_view_document?('document')

			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create superuser" do
		assert_difference 'User.count' do
			user = create_object
			user.roles << Role.find_by_name('superuser')
			assert  user.is_superuser?
			assert  user.is_super_user?
			assert  user.may_administrate?
			assert  user.may_edit?
			assert  user.may_interview?
			assert  user.may_read?
			assert  user.may_administrate?
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should deputize to create administrator" do
		u = create_object
		assert !u.role_names.include?('administrator')
		u.deputize
		assert  u.role_names.include?('administrator')
	end

#	test "should return non-nil mail" do
#		user = create_object
#		assert_not_nil user.mail
#	end

#	test "should return non-nil gravatar_url" do
#		user = create_object
#		assert_not_nil user.gravatar_url
#	end

	test "should respond to roles" do
		user = create_object
		assert user.respond_to?(:roles)
	end

	test "should have many roles" do
		u = create_object
		assert_equal 0, u.roles.length
		roles = Role.all
		assert roles.length > 0
		roles.each do |role|
			assert_difference("User.find(#{u.id}).role_names.length") {
			assert_difference("User.find(#{u.id}).roles.length") {
				u.roles << role
			} }
		end
	end

#	test "should return displayname as to_s" do
#		object = create_object(:displayname => "Mr Test")
#		assert_equal object.displayname, "Mr Test"
#		assert_equal object.displayname, "#{object}"
#	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_user

end
