class Photo < ActiveRecord::Base

	attr_accessible :title, :caption, :image
#:image_file_name
#, :image_content_type, :image_file_size, :image_updated_at

#	validates_presence_of :title
#	validates_length_of :title, :minimum => 4

	validations_from_yaml_file

	has_attached_file :image,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/photo.yml')
		))).result)[Rails.env]

	#	to avoid the following error
	#	Paperclip::Errors::MissingRequiredValidatorError
	do_not_validate_attachment_file_type :image

	def to_s
		title
	end

end
