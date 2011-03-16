
module GroupTestHelper

	def self.included(base)
		base.extend ClassMethods
		base.send(:include,InstanceMethods)
	end

	module InstanceMethods
	
		def create_a_membership
			@membership = create_membership
		end
	
		def create_membership(options={})
			Factory(:membership,{
				:group_role => GroupRole['reader']}.merge(options))
		end
	
		def group_roleless
			m = create_membership(
				:group => @membership.group,
				:group_role => nil )
			assert_equal @membership.group, m.group
			assert_nil m.group_role_id
			m.user
		end
	
		def group_reader
			m = create_membership(
				:group => @membership.group )
			assert_not_nil m.group_role_id
			assert_equal @membership.group, m.group
			m.user
		end
	
		def group_editor
			m = create_membership(
				:group => @membership.group,
				:group_role => GroupRole['editor'] )
			assert_not_nil m.group_role_id
			assert_equal @membership.group, m.group
			m.user
		end
	
		def group_moderator
			m = create_membership(
				:group => @membership.group,
				:group_role => GroupRole['moderator'] )
			assert_not_nil m.group_role_id
			assert_equal @membership.group, m.group
			m.user
		end
	
		def group_administrator
			m = create_membership(
				:group => @membership.group,
				:group_role => GroupRole['administrator'] )
			assert_not_nil m.group_role_id
			assert_equal @membership.group, m.group
			m.user
		end
	
		def nonmember_roleless
			m = create_membership(
				:group_role => nil )
			assert_not_equal @membership.group, m.group
			m.user
		end
	
		def nonmember_reader
			m = create_membership()
			assert_not_equal @membership.group, m.group
			m.user
		end
	
		def nonmember_editor
			m = create_membership(
				:group_role => GroupRole['editor'] )
			assert_not_equal @membership.group, m.group
			m.user
		end
	
		def nonmember_moderator
			m = create_membership(
				:group_role => GroupRole['moderator'] )
			assert_not_equal @membership.group, m.group
			m.user
		end
	
		def nonmember_administrator
			m = create_membership(
				:group_role => GroupRole['administrator'] )
			assert_not_equal @membership.group, m.group
			m.user
		end
	
		def membership_user
			@membership.user
		end
	
	end 

module ClassMethods

	#	centralization of group announcements and group events
	def assert_nested_group_asset(*args)
		options = HashWithIndifferentAccess.new({
			:attributes_method => :factory_attributes,
			:create_method     => :create_group_object
		}).merge(args.extract_options!)

#	expecting
#		:model
#		:factory
#		:attributes_key (default: model.underscore)
#		:attributes_method (default: factory_attributes)
#		:create_method (default: create_group_object)

		options[:attributes_key] ||= options[:model].underscore

		setup :create_a_membership

		#	no group_id
		assert_no_route(:get,:index)
		assert_no_route(:get,:new)
		assert_no_route(:post,:create)

		#	no id
		assert_no_route(:get, :show)
		assert_no_route(:get, :edit)
		assert_no_route(:put, :update)
		assert_no_route(:delete, :destroy)


		############################################################

		#
		#	Full (destroy) access roles
		#
		%w( super_user admin group_administrator group_moderator ).each do |cu|

			test "should destroy #{options[:attributes_key]} with #{cu} login" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				login_as send(cu)
				assert_difference("#{options[:model]}.count",-1){
					delete :destroy, 
						:group_id => @membership.group.id, 
						:id => object.id
				}
				assert_redirected_to group_path(object.group)
			end
	
			test "should NOT destroy #{options[:attributes_key]} with #{cu} login " <<
					"and without group" do
				object = send(options[:create_method],:group => nil)
				assert object.is_a?(options[:model].constantize)
				assert_nil object.reload.group
				login_as send(cu)
				assert_difference("#{options[:model]}.count",0){
					delete :destroy, 
						:group_id => @membership.group.id, 
						:id => object.id
				}
				assert_not_nil flash[:error]
				assert_redirected_to members_only_path
			end
	
			test "should NOT destroy #{options[:attributes_key]} with #{cu} login " <<
					"and invalid id" do
				login_as send(cu)
				assert_difference("#{options[:model]}.count",0){
					delete :destroy, 
						:group_id => @membership.group.id, 
						:id => 0
				}
				assert_not_nil flash[:error]
				assert_redirected_to members_only_path
			end
	
		end	#	Full (destroy) access roles

		#
		#	No destroy access roles
		#
		%w( editor interviewer active_user 
				group_roleless group_reader group_editor
				nonmember_administrator nonmember_moderator nonmember_editor
				nonmember_reader nonmember_roleless ).each do |cu|

			test "should NOT destroy #{options[:attributes_key]} with #{cu} login" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				login_as send(cu)
				assert_difference("#{options[:model]}.count",0){
					delete :destroy, 
						:group_id => @membership.group.id, 
						:id => object.id
				}
				assert_not_nil flash[:error]
				assert_redirected_to root_path	#	members_only_path
			end

		end	#	No destroy access roles

		############################################################

		#
		#	Edit access roles
		#
		%w( super_user admin group_administrator 
				group_moderator group_editor ).each do |cu|

			test "should get new #{options[:attributes_key]} with #{cu} login" do
				login_as send(cu)
				get :new, :group_id => @membership.group.id
				assert_response :success
				assert_template 'new'
			end
	
			test "should NOT get new #{options[:attributes_key]} with #{cu} login " <<
					"and without valid group" do
				login_as send(cu)
				get :new, :group_id => 0
				assert_not_nil flash[:error]
				assert_redirected_to members_only_path
			end
	
			test "should create #{options[:attributes_key]} with #{cu} login" do
				login_as user = send(cu)
				assert_difference("#{options[:model]}.count",1){
					post :create, :group_id => @membership.group.id, 
						options[:attributes_key] => send(options[:attributes_method])
				}
				assert       assigns(options[:attributes_key])
				assert_equal assigns(options[:attributes_key]).user,  user
				assert_equal assigns(options[:attributes_key]).group, @membership.group
				assert_redirected_to group_path(@membership.group)
			end
	
			test "should create #{options[:attributes_key]} with #{cu} login " <<
					"and ignore user_id" do
				login_as user = send(cu)
				assert_difference("#{options[:model]}.count",1){
					post :create, :group_id => @membership.group.id, 
						options[:attributes_key] => send(options[:attributes_method]).merge(
							:user_id => 0)
				}
				assert       assigns(options[:attributes_key])
				assert_equal assigns(options[:attributes_key]).user,  user
				assert_equal assigns(options[:attributes_key]).group, @membership.group
				assert_redirected_to group_path(@membership.group)
			end
	
			test "should create #{options[:attributes_key]} with #{cu} login " <<
					"and ignore group_id" do
				login_as user = send(cu)
				assert_difference("#{options[:model]}.count",1){
					post :create, :group_id => @membership.group.id, 
						options[:attributes_key] => send(options[:attributes_method]).merge(
							:group_id => 0 )
				}
				assert       assigns(options[:attributes_key])
				assert_equal assigns(options[:attributes_key]).user,  user
				assert_equal assigns(options[:attributes_key]).group, @membership.group
				assert_redirected_to group_path(@membership.group)
			end
	
			test "should NOT create #{options[:attributes_key]} with #{cu} login " <<
					"and without valid group" do
				login_as send(cu)
				assert_difference("#{options[:model]}.count",0){
					post :create, :group_id => 0, 
						options[:attributes_key] => send(options[:attributes_method])
				}
				assert_not_nil flash[:error]
				assert_redirected_to members_only_path
			end
	
			test "should NOT create #{options[:attributes_key]} with #{cu} login " <<
					"when create fails" do
				options[:model].constantize.any_instance.stubs(:create_or_update).returns(false)
				login_as send(cu)
				assert_difference("#{options[:model]}.count",0) do
					post :create, :group_id => @membership.group.id, 
						options[:attributes_key] => send(options[:attributes_method])
				end
				assert_response :success
				assert_template 'new'
				assert_not_nil flash[:error]
			end
	
			test "should NOT create #{options[:attributes_key]} with #{cu} login " <<
					"and invalid #{options[:attributes_key]}" do
				options[:model].constantize.any_instance.stubs(:valid?).returns(false)
				login_as send(cu)
				assert_difference("#{options[:model]}.count",0) do
					post :create, :group_id => @membership.group.id, 
						options[:attributes_key] => send(options[:attributes_method])
				end
				assert_response :success
				assert_template 'new'
				assert_not_nil flash[:error]
			end
	
			test "should edit #{options[:attributes_key]} with #{cu} login" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				login_as send(cu)
				get :edit, :group_id => @membership.group.id, :id => object.id
				assert_response :success
				assert_template 'edit'
			end
	
			test "should NOT edit #{options[:attributes_key]} with #{cu} login " <<
					"without valid id" do
				login_as send(cu)
				get :edit, :group_id => @membership.group.id, :id => 0
				assert_not_nil flash[:error]
				assert_redirected_to members_only_path
			end
	
			test "should NOT edit #{options[:attributes_key]} with #{cu} login " <<
					"and without group" do
				object = send(options[:create_method],:group => nil)
				assert object.is_a?(options[:model].constantize)
				assert_nil object.reload.group
				login_as send(cu)
				get :edit, :group_id => @membership.group.id, :id => object.id
				assert_not_nil flash[:error]
				assert_redirected_to members_only_path
			end
	
			test "should update #{options[:attributes_key]} with #{cu} login" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				assert_equal object.group, @membership.group
				sleep 1
				login_as send(cu)
				assert_changes("#{options[:model]}.find(#{object.id}).updated_at") {
					put :update, :group_id => @membership.group.id, :id => object.id, 
						options[:attributes_key] => send(options[:attributes_method])
				}
				assert_redirected_to group_path(@membership.group)
			end
	
			test "should NOT update groupless #{options[:attributes_key]} with #{cu} login" do
				object = send(options[:create_method],:group => nil)
				assert object.is_a?(options[:model].constantize)
				assert_nil object.reload.group
				login_as send(cu)
				deny_changes("#{options[:model]}.find(#{object.id}).updated_at") {
					put :update, :group_id => @membership.group.id, :id => object.id, 
						options[:attributes_key] => send(options[:attributes_method])
				}
				assert_not_nil flash[:error]
				assert_redirected_to members_only_path
			end
	
			test "should NOT update #{options[:attributes_key]} with #{cu} login " <<
					"when update fails" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				options[:model].constantize.any_instance.stubs(:create_or_update).returns(false)
				login_as send(cu)
				deny_changes("#{options[:model]}.find(#{object.id}).updated_at") {
					put :update, :group_id => @membership.group.id, :id => object.id, 
						options[:attributes_key] => send(options[:attributes_method])
				}
				assert_response :success
				assert_template 'edit'
				assert_not_nil flash[:error]
			end
	
			test "should NOT update #{options[:attributes_key]} with #{cu} login " <<
					"and invalid #{options[:attributes_key]}" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				options[:model].constantize.any_instance.stubs(:valid?).returns(false)
				login_as send(cu)
				deny_changes("#{options[:model]}.find(#{object.id}).updated_at") {
					put :update, :group_id => @membership.group.id, :id => object.id, 
						options[:attributes_key] => send(options[:attributes_method])
				}
				assert_response :success
				assert_template 'edit'
				assert_not_nil flash[:error]
			end
	
			test "should NOT update #{options[:attributes_key]} with #{cu} login " <<
					"and invalid id" do
				login_as send(cu)
				put :update, :group_id => @membership.group.id, :id => 0, 
					options[:attributes_key] => send(options[:attributes_method])
				assert_not_nil flash[:error]
				assert_redirected_to members_only_path
			end

			test "should update #{options[:attributes_key]} with #{cu} login " <<
					"and ignore group_id change" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				assert_equal object.group, @membership.group
				sleep 1
				login_as user = send(cu)
				assert_changes("#{options[:model]}.find(#{object.id}).updated_at") {
					put :update, :group_id => @membership.group.id, :id => object.id, 
						options[:attributes_key] => send(options[:attributes_method]).merge(
							:group_id => 0 )
				}
				assert           assigns(options[:attributes_key])
				assert_equal     assigns(options[:attributes_key]).group, @membership.group
				assert_not_equal assigns(options[:attributes_key]).user,  @membership.user
				assert_not_equal assigns(options[:attributes_key]).user,  user
				assert_redirected_to group_path(@membership.group)
			end
	
			test "should update #{options[:attributes_key]} with #{cu} login " <<
					"and ignore user_id change" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				assert_equal object.group, @membership.group
				sleep 1
				login_as user = send(cu)
				assert_changes("#{options[:model]}.find(#{object.id}).updated_at") {
					put :update, :group_id => @membership.group.id, :id => object.id, 
						options[:attributes_key] => send(options[:attributes_method]).merge(
							:user_id => 0 )
				}
				assert           assigns(options[:attributes_key])
				assert_equal     assigns(options[:attributes_key]).group, @membership.group
				assert_not_equal assigns(options[:attributes_key]).user,  @membership.user
				assert_not_equal assigns(options[:attributes_key]).user,  user
				assert_not_equal assigns(options[:attributes_key]).user_id, 0
				assert_redirected_to group_path(@membership.group)
			end
	
		end	#	Edit access roles

		#
		#	No edit access roles
		#
		%w( editor interviewer active_user 
				group_roleless group_reader
				nonmember_administrator nonmember_moderator nonmember_editor
				nonmember_reader nonmember_roleless ).each do |cu|

			test "should NOT get new #{options[:attributes_key]} with #{cu} login" do
				login_as send(cu)
				get :new, :group_id => @membership.group.id
				assert_redirected_to root_path
			end
	
			test "should NOT create #{options[:attributes_key]} with #{cu} login" do
				login_as send(cu)
				assert_difference("#{options[:model]}.count",0){
					post :create, :group_id => @membership.group.id, 
						options[:attributes_key] => send(options[:attributes_method])
				}
				assert_redirected_to root_path
			end
	
			test "should NOT edit #{options[:attributes_key]} with #{cu} login" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				login_as send(cu)
				get :edit, :group_id => @membership.group.id, :id => object.id
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end
	
			test "should NOT update #{options[:attributes_key]} with #{cu} login" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				login_as send(cu)
				deny_changes("#{options[:model]}.find(#{object.id}).updated_at") {
					put :update, :group_id => @membership.group.id, :id => object.id, 
						options[:attributes_key] => send(options[:attributes_method])
				}
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end

		end	#	No edit access roles

		############################################################

		#
		#	Read access roles
		#
		%w( super_user admin group_administrator 
				group_moderator group_editor group_reader ).each do |cu|

			test "should show #{options[:attributes_key]} with #{cu} login" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				login_as send(cu)
				get :show, :group_id => @membership.group.id, :id => object.id
				assert_response :success
				assert_template 'show'
			end

			test "should get all #{options[:attributes_key].to_s.pluralize} with #{cu} login" do
				login_as send(cu)
				get :index, :group_id => @membership.group.id
				assert_response :success
				assert_template 'index'
			end

		end	#	Read access roles

		#
		#	No access roles ( No read access roles )
		#
		%w( editor interviewer active_user group_roleless
				nonmember_administrator nonmember_moderator nonmember_editor
				nonmember_reader nonmember_roleless ).each do |cu|

#			test "should NOT get new #{options[:attributes_key]} with #{cu} login" do
#				login_as send(cu)
#				get :new, :group_id => @membership.group.id
#				assert_redirected_to root_path
#			end
#	
#			test "should NOT create #{options[:attributes_key]} with #{cu} login" do
#				login_as send(cu)
#				assert_difference("#{options[:model]}.count",0){
#					post :create, :group_id => @membership.group.id, 
#						options[:attributes_key] => send(options[:attributes_method])
#				}
#				assert_redirected_to root_path
#			end
#	
#			test "should NOT edit #{options[:attributes_key]} with #{cu} login" do
#				object = send(options[:create_method],:group => @membership.group)
#				assert object.is_a?(options[:model].constantize)
#				login_as send(cu)
#				get :edit, :group_id => @membership.group.id, :id => object.id
#				assert_not_nil flash[:error]
#				assert_redirected_to root_path
#			end
#	
#			test "should NOT update #{options[:attributes_key]} with #{cu} login" do
#				object = send(options[:create_method],:group => @membership.group)
#				assert object.is_a?(options[:model].constantize)
#				login_as send(cu)
#				deny_changes("#{options[:model]}.find(#{object.id}).updated_at") {
#					put :update, :group_id => @membership.group.id, :id => object.id, 
#						options[:attributes_key] => send(options[:attributes_method])
#				}
#				assert_not_nil flash[:error]
#				assert_redirected_to root_path
#			end
#	
#			test "should NOT destroy #{options[:attributes_key]} with #{cu} login" do
#				object = send(options[:create_method],:group => @membership.group)
#				assert object.is_a?(options[:model].constantize)
#				login_as send(cu)
#				assert_difference("#{options[:model]}.count",0){
#					delete :destroy, 	
#						:group_id => @membership.group.id, 	
#						:id => object.id
#				}
#				assert_not_nil flash[:error]
#				assert_redirected_to root_path
#			end
	
			test "should NOT show #{options[:attributes_key]} with #{cu} login" do
				object = send(options[:create_method],:group => @membership.group)
				assert object.is_a?(options[:model].constantize)
				login_as send(cu)
				get :show, 
					:group_id => @membership.group.id, 
					:id => object.id
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end
	
			test "should NOT get index #{options[:attributes_key].to_s.pluralize} with #{cu} login" do
				login_as send(cu)
				get :index, :group_id => @membership.group.id
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end
	
		end	#	No access roles

		############################################################

		#
		#	No login
		#

		test "should NOT get new #{options[:attributes_key]} without login" do
			get :new, 
				:group_id => @membership.group.id
			assert_redirected_to_login
		end
	
		test "should NOT create #{options[:attributes_key]} without login" do
			assert_difference("#{options[:model]}.count",0){
				post :create, 
					:group_id => @membership.group.id, 
					options[:attributes_key] => send(options[:attributes_method])
			}
			assert_redirected_to_login
		end

		test "should NOT edit #{options[:attributes_key]} without login" do
			object = send(options[:create_method],:group => @membership.group)
			assert object.is_a?(options[:model].constantize)
			get :edit, :group_id => @membership.group.id, :id => object.id
			assert_redirected_to_login
		end
	
		test "should NOT update #{options[:attributes_key]} without login" do
			object = send(options[:create_method],:group => @membership.group)
			assert object.is_a?(options[:model].constantize)
			sleep 1
			deny_changes("#{options[:model]}.find(#{object.id}).updated_at") {
				put :update, 
					:group_id => @membership.group.id, 
					:id => object.id, 
					options[:attributes_key] => send(options[:attributes_method])
			}
			assert_redirected_to_login
		end
	
		test "should NOT destroy #{options[:attributes_key]} without login" do
			object = send(options[:create_method],:group => @membership.group)
			assert object.is_a?(options[:model].constantize)
			assert_difference("#{options[:model]}.count",0){
				delete :destroy, 
					:group_id => @membership.group.id, 
					:id => object.id
			}
			assert_redirected_to_login
		end
	
		test "should NOT get index #{options[:attributes_key].to_s.pluralize} without login" do
			get :index, :group_id => @membership.group.id
			assert_redirected_to_login
		end

		test "should NOT show #{options[:attributes_key]} without login" do
			object = send(options[:create_method],:group => @membership.group)
			assert object.is_a?(options[:model].constantize)
			get :show, 
				:group_id => @membership.group.id, 
				:id => object.id
			assert_redirected_to_login
		end	#	End No login
	
	end	# assert_nested_group_asset(options={})

end	#	module ClassMethods
end	#	module GroupTestHelper
ActionController::TestCase.send(:include, GroupTestHelper )
