require 'test_helper'

class PhotosControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Photo',
		:actions => [:new,:create,:edit,:update,:destroy,:show,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create(options={})
		Factory(:photo,options)
	end
	def factory_attributes(options={})
		Factory.attributes_for(:photo,options)
	end

	assert_access_with_https
	assert_access_with_login({
		:logins => [:superuser,:administrator,:editor]})

	assert_no_access_with_http 
	assert_no_access_with_login({ 
		:logins => [:interviewer,:reader,:active_user] })
	assert_no_access_without_login

end
