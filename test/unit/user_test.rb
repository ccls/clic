require 'test_helper'

class UserTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:username)
	assert_should_require_unique(:username)
	assert_should_require(:first_name)
	assert_should_require(:last_name)
	assert_should_require(:degrees)
	assert_should_require(:title)
	assert_should_require(:profession)
	assert_should_require(:organization)
	assert_should_require(:address)
	assert_should_require(:phone_number)
	assert_should_not_require(:research_interests)
	assert_should_not_require(:selected_publications)
	assert_should_have_many(:user_professions)
	assert_should_have_many(:memberships)
#	assert_should_have_many(:announcements)
	assert_should_have_many(:events)
	assert_should_have_many(:topics)
	assert_should_have_many(:posts)
#	polymorphism causing an issue here I think
#	assert_should_have_many(:documents, :as => :owner)
	assert_should_have_many(:group_documents)
	assert_should_protect(:approved)


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
			@new_object = Factory(:user,{
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
			@new_object = Factory(:user,{
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
			@new_object = Factory(:user,{
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
			@new_object = Factory(:user,{
				:membership_requests => { 
					Group.joinable.first.id.to_s => {
						:group_role_id => '' }
				} 
			})
		} }
	end

	test "should be unapproved after create" do
		assert_difference("User.count",1) do
			@user = Factory(:user)
		end
		assert !@user.reload.approved?
	end

	test "should be approved after assigned role" do
		assert_difference("User.count",1) do
			@user = Factory(:user)
		end
		assert !@user.reload.approved?
		assert_difference("User.find(#{@user.id}).roles.length",1) do
			@user.roles << Role.find_or_create_by_name('editor')
		end
		assert @user.reload.approved?
	end

	test "should be approved after membership approved" do
		assert_difference("User.count",1) do
			@user = Factory(:user)
		end
		assert !@user.reload.approved?
		deny_changes("User.find(#{@user.id}).perishable_token") {
			assert_difference("User.find(#{@user.id}).memberships.length",1) {
			assert_difference("Membership.count",1) {
				@m = Factory(:membership, :user => @user)
			} }
			assert_equal @user, @m.user
			assert !@m.reload.approved?
			@m.approve!
			assert @m.reload.approved?
			assert @user.reload.approved?
		}
	end

end
