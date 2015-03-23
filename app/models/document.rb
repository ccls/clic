require 'hmac-sha1'
#
#	http://amazon.rubyforge.org/
#
class Document < ActiveRecord::Base

#	polymorphism is unecessary now that GroupDocument is its own class
	belongs_to :owner, :polymorphic => true

	validations_from_yaml_file

	before_validation :nullify_blank_document_file_name

	has_attached_file :document,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/document.yml')
		))).result)[Rails.env]

	#	to avoid the following error
	#	Paperclip::Errors::MissingRequiredValidatorError
	do_not_validate_attachment_file_type :document

	def nullify_blank_document_file_name
		self.document_file_name = nil if document_file_name.blank?
	end

	def to_s
		title.to_s
	end

end
