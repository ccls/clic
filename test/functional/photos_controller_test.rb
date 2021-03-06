require 'test_helper'

class PhotosControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Photo',
		:actions => [:new,:create,:edit,:update,:destroy,:show,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create(options={})
		FactoryGirl.create(:photo,options)
	end
	def factory_attributes(options={})
		FactoryGirl.attributes_for(:photo,options)
	end

	assert_access_with_login({ :logins => site_editors })

	assert_no_access_with_login({ :logins => non_site_editors })
	assert_no_access_without_login

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	add_strong_parameters_tests( :photo, [:title, :image, :caption ])

end
