require 'test_helper'

class UserTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:username)
	assert_should_require_unique(:username)
	assert_should_have_many(:memberships)
	assert_should_have_many(:announcements)
	assert_should_have_many(:events)
	assert_should_have_many(:documents, :as => :owner)
	assert_should_have_many(:group_documents)

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

end
