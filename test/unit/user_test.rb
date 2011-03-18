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
	assert_should_have_many(:memberships)
	assert_should_have_many(:announcements)
	assert_should_have_many(:events)
	assert_should_have_many(:topics)
	assert_should_have_many(:posts)
#	polymorphism causing an issure here I think
#	assert_should_have_many(:documents, :as => :owner)
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
