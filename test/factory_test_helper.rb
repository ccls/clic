module FactoryTestHelper

	#	
	#	If these aren't defined, autotest can hang indefinitely
	#	and you won't know why.
	#
	#	I think that there is a way to tell Factory Girl to use
	#	"save" instead of "save!" which would have removed the
	#	need for this MOSTLY.  There are a few exceptions.
	FactoryGirl.factories.collect(&:name).each do |object|
		#
		#	define a method that is commonly used in these class level tests
		#	I'd actually prefer to not do this, but is very helpful.
		#
		define_method "create_#{object}" do |*args|
			options = args.extract_options!
			new_object = FactoryGirl.build(object,options)
			new_object.save
			new_object
		end
	end


	def remove_object_with_group_documents(object)
		object.group_documents.each {|gdoc| 
			remove_object_and_document_attachment(gdoc)
		}
	end

	def remove_object_and_document_attachment(object)
		document_path = object.document.path
		object.document.destroy
		object.destroy
		assert !File.exists?(document_path)
	end

	def group_doc_attributes_with_attachment(options={})
		FactoryGirl.attributes_for(:group_document,{
			:document => Rack::Test::UploadedFile.new(File.dirname(__FILE__) +
				'/assets/edit_save_wireframe.pdf')
		}.merge(options))
#			:document => File.open(File.dirname(__FILE__) + 
#				'/assets/edit_save_wireframe.pdf')}.merge(options))
	end

	def active_user(options={})
		u = FactoryGirl.create(:user, options)
		#	leave this special save here just in case I change things.
		#	although this would need changed for UCB CAS.
		#	u.save_without_session_maintenance
		#	u
	end
	alias_method :user, :active_user

	def superuser(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('superuser')
		u
	end
	alias_method :super_user, :superuser

	def admin_user(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('administrator')
		u
	end
	alias_method :admin, :admin_user
	alias_method :administrator, :admin_user

	def interviewer(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('interviewer')
		u
	end

	def reader(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('reader')
		u
	end
#	alias_method :employee, :reader

	def editor(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('editor')
		u
	end

end
ActiveSupport::TestCase.send(:include, FactoryTestHelper)
