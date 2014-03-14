#	==	requires
#	*	path ( unique, > 1 char and starts with a / )
#	*	menu ( unique and > 3 chars )
#	*	title ( > 3 chars )
#	*	body ( > 3 chars )
#
#	==	scope(s)
#	*	not_home (returns those pages where path is not just '/')
#	*	roots
#
#	uses acts_as_list for parent / child relationship.  As this
#	is only a parent and child and no deeper, its ok.  If it
#	were to get any deeper, the list should probably be changed
#	to something like a nested set.
class Page < ActiveRecord::Base

#	default scopes are EVIL.  They seem to take precedence
#	over you actual query which seems really stupid
#	removing all in rails 3 which will probably require
#	modifications to compensate in the methods that expected them
#	default_scope :order => :position

	acts_as_list :scope => :parent_id
#	acts_as_list :scope => "parent_id \#{(parent_id.nil?)?'IS NULL':'= parent_id'} AND locale = '\#{locale}'"

	validates_presence_of :path
	validates_length_of :path,  :minimum => 1
	validates_format_of :path,  :with => /\A\//
#	validates_presence_of :menu_en
	validates_length_of :menu_en,  :minimum => 4
#	validates_presence_of :title_en
	validates_length_of :title_en, :minimum => 4
#	validates_presence_of :body_en
	validates_length_of :body_en,  :minimum => 4
	validates_uniqueness_of :menu_en
	validates_uniqueness_of :path

	belongs_to :parent, :class_name => 'Page'
	has_many :children, :class_name => 'Page', :foreign_key => 'parent_id',
		:dependent => :nullify
	
	scope :roots,    ->{ where( :parent_id => nil, :hide_menu => false ) }
	scope :hidden,   ->{ where( :hide_menu => true ) }
	scope :not_home, ->{ where( "path != '/'" ) }

	attr_accessible :path, :parent_id, :hide_menu,
		:menu,  :menu_en,  :menu_es, 
		:title, :title_en, :title_es,
		:body,  :body_en,  :body_es

	before_validation :adjust_path

	def to_s
		title
	end

	def adjust_path
		unless self.path.nil?
			#	remove any duplicate /'s
#			self.path = path.gsub(/\/+/,'/')
			self.path.gsub!(/\/+/,'/')

			#	add leading / if none
#			self.path = path.downcase
			self.path.downcase!
		end
	end

	#	scopes ALWAYS return an "Array"
	#	so if ONLY want one, MUST use a method.
	#	by_path returns the one(max) page that
	#	matches the given path.
	def self.by_path(path)
#		page = find(:first, :conditions => { :path   => path.downcase })
		page = where( :path => path.downcase ).first
	end

	def root
		page = self
		until page.parent == nil
			page = page.parent
		end 
		page
	end

	def is_home?
		self.path == "/"
	end

	def menu(locale='en')	#	sends session[:locale] which can be nil
		r = send("menu_#{locale||'en'}")
		( r.blank? ) ? send(:menu_en) : r
	end
	def menu=(new_menu)
		self.menu_en = new_menu
	end
	def title(locale='en')	#	sends session[:locale] which can be nil
		r = send("title_#{locale||'en'}")
		( r.blank? ) ? send(:title_en) : r
	end
	def title=(new_title)
		self.title_en = new_title
	end
	def body(locale='en')	#	sends session[:locale] which can be nil
		r = send("body_#{locale||'en'}")
		( r.blank? ) ? send(:body_en) : r
	end
	def body=(new_body)
		self.body_en = new_body
	end

#	#	Virtual attributes
#	%w( menu title body ).each do |attr|
#		define_method "#{attr}" do |*args|
#			r = send("#{attr}_#{args[0]||'en'}")
#			(r.blank?) ? send("#{attr}_en") : r
#		end
#		define_method "#{attr}=" do |new_val|
#			self.send("#{attr}_en=",new_val)
#		end
##		attr_accessible attr.to_sym
##		%w( en es ).each do |lang|
##			attr_accessible "#{attr}_#{lang}".to_sym
##		end
#	end

end
