# A sample Gemfile
source "http://rubygems.org"
source "http://gems.rubyforge.org"
source "http://gemcutter.org"

#	I don't believe that this source is active any longer.
source "http://gems.github.com"





gem 'rails', '~>3.2'	#.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'




gem 'tinymce-rails'



#	rubygems > 1.6.2 is EVIL!  If you update, you deal with it.
#		generates all kinds of new errors and deprecation warnings
#		somehow loads older versions of gems, then bitches when you try to load the newest.
#		(may be fixable with "gem pristine --all --no-extensions", but haven't tried)
#	rake 0.9.0 caused some errors.  can't remember
#	arel > 2.0.2 caused some errors.
#	some gem versions require rails 3, so have to use older versions
#		authlogic, will_paginate

#	gem install rubygems-update -v '1.6.2'
#	update_rubygems


#
#	NO SPACES BETWEEN OPERATOR AND VERSION NUMBER!
#
#gem "rake"	#, '=0.8.7'
#gem "rails", '~> 3.2.2'	#, "~>2"

#	Why?  Can't remember.
gem "RedCloth"	#, '<4.2.8'

gem "arel"	#, "=2.0.2"

#	Trying to remove Chronic usage
#	still in calnet_authenticated
#	0.6.7 doesn't install in jruby?
gem "chronic"	#,	'<=0.6.6'

#gem "haml"
gem "hpricot"
#gem "i18n"
#gem "jrails"

#gem "rack", "=1.1.2"

gem "ryanb-acts-as-list", :require => 'acts_as_list'
#gem "ssl_requirement"
gem "will_paginate"	#, "~>2"


#	1.3.5 causes all kinds of 
#	gems-gems-......jar
#	files to be put in /lib/ which for whatever reasons
#	causes a lot of errors.
#	As I see no need for any upgrade, don't.
#gem "warbler", '=1.3.2'

#
#	I'm surprise that this works with the creation of 
#	the whole Gemfile.lock thing.
#
#if RUBY_PLATFORM =~ /java/
#	#	jruby-jars-1.6.6 causes issues
#	gem "jruby-jars", "=1.6.5"
#	gem "jruby-openssl"
#	gem "jruby-rack", "=1.0.10"
#	gem "jdbc-mysql"
#	gem "jdbc-sqlite3"
#	gem "activerecord-jdbcsqlite3-adapter"
#	gem "activerecord-jdbcmysql-adapter"
#else
	gem 'mysql'
	gem 'mysql2'
#	gem "sqlite3"
#	gem 'rcov', :group => :test
# This does not work as well as rcov used to, imo.
gem "simplecov", :require => false

#end



#Java::JavaLang::ArrayIndexOutOfBoundsException: An error occured while installing rubyzip (0.9.5), and Bundler cannot continue.
#	why
#gem 'rubyzip', '=0.9.4'	#	0.9.5 fails
#	not true anymore (warbler uses this)

#	Used for cvs parsing on data import
#	Also used to csv output.
#	Not used in app, but used in rake tasks
#gem "fastercsv"

#	2.4.3, 2.4.5 causes a lot of ...
#	NameError: `@[]' is not allowed as an instance variable name
#    paperclip (2.4.5) lib/paperclip/options.rb:60:in `instance_variable_get'
#    paperclip (2.4.5) lib/paperclip/options.rb:60:in `method_missing'
gem "paperclip"	#, '=2.4.2'	#	only used by buffler and clic

#	rarely used
gem "rdoc"	#, "~>2"
gem "aws-s3"
gem 'aws-sdk'



gem "authlogic"	#, "~> 2"
gem "ruby-hmac"


#gem "rsolr", "=0.12.1"
#gem "sunspot", "=1.2.1"
#gem "sunspot_rails", "=1.2.1"


group :test do
	gem "ccls-html_test"

#	Its always something
#Java::JavaLang::ArrayIndexOutOfBoundsException: An error occured while installing mocha (0.11.0), and Bundler cannot continue.
#Make sure that `gem install mocha -v '0.11.0'` succeeds before bundling.
	gem "mocha", '0.10.5', :require => false

	gem "autotest-rails", :require => 'autotest/rails'
	gem 'ZenTest', '=4.8.3'	#	'~>4.5.0'
	#	gem "thoughtbot-factory_girl", :require => "factory_girl"
	gem "factory_girl", "~> 2.6.0"
	# rails 3 version
	gem "factory_girl_rails"
end

