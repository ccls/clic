require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Membership',
		:actions => [:edit,:update,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_membership
	}
	def factory_attributes(options={})
		FactoryGirl.attributes_for(:membership, {
			:group_role_id => GroupRole['editor'].id }.merge(options))
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login({    :logins => site_administrators,
		:no_redirect_check => true })	#	for membership update failure only
	assert_no_access_with_login({ :logins => non_site_administrators })
	assert_no_access_without_login

	site_administrators.each do |cu|
	
		test "should approve membership with #{cu} login and no params" do
			membership = create_membership(:approved => false)
			login_as send(cu)
			assert !membership.approved?
			assert_changes("Membership.find(#{membership.id}).approved") do
				put :approve, :id => membership.id
			end
			assert  membership.reload.approved?
			assert_redirected_to memberships_path
		end
	
		test "should NOT approve membership with #{cu} login and update fails" do
			membership = create_membership(:approved => false)
			Membership.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert !membership.approved?
			deny_changes("Membership.find(#{membership.id}).approved") do
				put :approve, :id => membership.id
			end
			assert !membership.reload.approved?
			assert_not_nil flash[:error]
			assert_redirected_to memberships_path
		end

		test "should update membership group role with #{cu} login and new role" do
			create_a_membership
			login_as send(cu)
			assert_equal @membership.group_role, GroupRole['reader']
			assert_changes("Membership.find(#{@membership.id}).group_role_id") do
				put :update, :id => @membership.id, :membership => { 
					:group_role_id => GroupRole['editor'].id }
			end
			assert_equal @membership.reload.group_role, GroupRole['editor']
			assert_redirected_to memberships_path
		end

		test "should NOT update membership group role with #{cu} login and update fails" do
			create_a_membership
			login_as send(cu)
			Membership.any_instance.stubs(:create_or_update).returns(false)
			assert_equal @membership.group_role, GroupRole['reader']
			deny_changes("Membership.find(#{@membership.id}).group_role_id") do
				put :update, :id => @membership.id, :membership => { 
					:group_role_id => GroupRole['editor'].id }
			end
			assert_not_nil flash[:error]
			assert_redirected_to memberships_path
		end

		test "should NOT update membership group role with #{cu} login and invalid group_role_id" do
			create_a_membership
			login_as send(cu)
			Membership.any_instance.stubs(:create_or_update).returns(false)
			assert_equal @membership.group_role, GroupRole['reader']
			deny_changes("Membership.find(#{@membership.id}).group_role_id") do
				put :update, :id => @membership.id, :membership => { 
					:group_role_id => 0 }
			end
			assert_not_nil flash[:error]
			assert_redirected_to memberships_path
		end
	
	end

end
