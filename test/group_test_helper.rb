
module GroupTestHelper

	def self.included(base)
		base.extend ClassMethods
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

		# a @membership is required so that those group roles will work
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

		def self.group_asset_readers
			@group_asset_readers ||= (group_asset_editors + %w(group_reader))
		end
		def self.group_asset_editors
			@group_asset_editors ||= (group_asset_destroyers + %w(group_editor))
		end
		def self.group_asset_destroyers
#			@group_asset_destroyers ||= %w( superuser administrator group_administrator group_moderator )
			@group_asset_destroyers ||= %w( superuser administrator group_moderator )
		end

		############################################################

		#
		#	Full (destroy) access roles
		#
		group_asset_destroyers.each do |cu|

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
		( all_test_roles - group_asset_destroyers ).each do |cu|

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
		group_asset_editors.each do |cu|

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
		( all_test_roles - group_asset_editors ).each do |cu|

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
		group_asset_readers.each do |cu|

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
		( all_test_roles - group_asset_readers ).each do |cu|

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
