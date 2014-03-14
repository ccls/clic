require 'test_helper'

class PublicationSubjectTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:name)
	assert_should_require_unique(:name)
#	assert_should_have_many( :publications )
	assert_should_act_as_list
	assert_should_require_attribute_length( :name,  :maximum => 250 )

	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

	test "should be 'other' for publication subject 'other'" do
		ps = PublicationSubject.where( :name => 'Other' )
		assert_equal 1, ps.length
		assert ps.first.is_other?
	end

	test "should NOT be 'other' for publication subject NOT 'other'" do
		pss = PublicationSubject.where( "name !=  'Other'" )
		assert pss.length > 1
		pss.each do |ps|
			assert !ps.is_other?
		end
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_publication_subject

end
