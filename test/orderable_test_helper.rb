module OrderableTestHelper

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

#		So far, this is alway the same so no real arguments
#		Making a bunch of other conventional assumptions as well.
		def assert_orderable(*args)
#			options = args.extract_options!

			resources = self.controller_class.controller_name
			model = resources.camelize.singularize.constantize

			site_administrators.each do |cu|

				test "should order #{resources} with #{cu} login" do
					login_as send(cu)
					orderable = []
					3.times{ orderable.push(factory_create) }
					before_ids = model.all.collect(&:id)
					post :order, :ids => before_ids.reverse
					after_ids = model.all.collect(&:id)
					assert_equal after_ids, before_ids.reverse
					assert_redirected_to :controller => resources, :action => 'index'
				end

#				test "should NOT order #{resources} with nonarray ids and " <<
#						"with #{cu} login" do
#					login_as send(cu)
##	actually converts this to an array I think, as it fails like it
#					post :order, :ids => 0
#puts flash[:error]
#					assert_not_nil flash[:error]
#					assert_redirected_to :controller => resources, :action => 'index'
#				end

				test "should NOT order #{resources} without ids and " <<
						"with #{cu} login" do
					login_as send(cu)
					post :order
					assert_not_nil flash[:error]
					assert_redirected_to :controller => resources, :action => 'index'
				end

				test "should NOT order #{resources} with invalid ids and #{cu} login" do
					login_as send(cu)
					post :order, :ids => [0]
					assert_not_nil flash[:error]
					assert_redirected_to :controller => resources, :action => 'index'
				end

			end

			non_site_administrators.each do |cu|

				test "should NOT order #{resources} with #{cu} login" do
					login_as send(cu)
					orderable = []
					3.times{ orderable.push(factory_create) }
					before_ids = model.all.collect(&:id)
					post :order, :ids => before_ids.reverse
					assert_not_nil flash[:error]
					assert_redirected_to root_path
				end

			end

			test "should NOT order #{resources} without login" do
				orderable = []
				3.times{ orderable.push(factory_create) }
				before_ids = model.all.collect(&:id)
				post :order, :ids => before_ids.reverse
				assert_redirected_to_login
			end

		end

	end

end
ActionController::TestCase.send(:include, OrderableTestHelper )
