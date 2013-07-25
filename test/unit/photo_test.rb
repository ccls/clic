require 'test_helper'

class PhotoTest < ActiveSupport::TestCase

	assert_should_require(:title)

	test "should create photo" do
		assert_difference 'Photo.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should use local filesystem to store attachment in test" do
		photo = FactoryGirl.create(:photo, :image_file_name => 'bogus_file_name')
		assert !photo.image.exists?
		assert !File.exists?(photo.image.path)
		assert_equal :filesystem, photo.image.options[:storage]
	end

	test "should use amazon to store attachment in production" do
		Rails.stubs(:env).returns('production')
		load 'photo.rb'
		photo = FactoryGirl.create(:photo, :image_file_name => 'bogus_file_name')
		assert !photo.image.exists?
		assert !File.exists?(photo.image.path)

		assert_equal :s3, photo.image.options[:storage]
		assert_equal :public_read, photo.image.options[:s3_permissions]

		#	not private, nevertheless
		#	is an image so needs additional /original/ folder
 		assert_match %r{\Ahttp(s)?://clic.s3.amazonaws.com/photos/\d+/original/bogus_file_name\?AWSAccessKeyId=\w+&Expires=\d+&Signature=.+\z}, photo.image.expiring_url

		# WE MUST UNDO these has_attached_file modifications
		Rails.unstub(:env)
		load 'photo.rb'
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_photo

end
