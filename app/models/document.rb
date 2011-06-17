require 'hmac-sha1'
#
#	http://amazon.rubyforge.org/
#
class Document < ActiveRecord::Base

#	polymorphism is unecessary now that GroupDocument is its own class
	belongs_to :owner, :polymorphic => true

	validates_presence_of :title
	validates_length_of   :title, :in => 4..250

#	WHY?
	validates_uniqueness_of :document_file_name, :allow_nil => true

	before_validation :nullify_blank_document_file_name

	has_attached_file :document,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/document.yml')
		))).result)[Rails.env]

	def nullify_blank_document_file_name
		self.document_file_name = nil if document_file_name.blank?
	end

	def to_s
		title
	end

end
