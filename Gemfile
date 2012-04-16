# A sample Gemfile
source "http://rubygems.org"
source "http://gems.rubyforge.org"
source "http://gemcutter.org"

#	I don't believe that this source is active any longer.
source "http://gems.github.com"


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
gem "rake", '=0.8.7'
gem "rails", "~>2"

#	Why?  Can't remember.
gem "RedCloth", '<4.2.8'

gem "arel", "=2.0.2"

#	Trying to remove Chronic usage
#	still in calnet_authenticated
#	0.6.7 doesn't install in jruby?
gem "chronic",	'<=0.6.6'

gem "haml"
gem "hpricot"
gem "i18n"
gem "jrails"

gem "rack", "=1.1.2"

gem "ryanb-acts-as-list"
gem "ssl_requirement"
gem "will_paginate", "~>2"


#	1.3.5 causes all kinds of 
#	gems-gems-......jar
#	files to be put in /lib/ which for whatever reasons
#	causes a lot of errors.
#	As I see no need for any upgrade, don't.
gem "warbler", '=1.3.2'

#
#	I'm surprise that this works with the creation of 
#	the whole Gemfile.lock thing.
#
if RUBY_PLATFORM =~ /java/
	#	jruby-jars-1.6.6 causes issues
	gem "jruby-jars", "=1.6.5"
	gem "jruby-openssl"
	gem "jruby-rack", "=1.0.10"
	gem "jdbc-mysql"
	gem "jdbc-sqlite3"
	gem "activerecord-jdbcsqlite3-adapter"
	gem "activerecord-jdbcmysql-adapter"
else
	gem 'mysql'
	gem "sqlite3"
	gem 'rcov', :group => :test
end



#Java::JavaLang::ArrayIndexOutOfBoundsException: An error occured while installing rubyzip (0.9.5), and Bundler cannot continue.
#	why
#gem 'rubyzip', '=0.9.4'	#	0.9.5 fails
#	not true anymore (warbler uses this)

#	Used for cvs parsing on data import
#	Also used to csv output.
#	Not used in app, but used in rake tasks
gem "fastercsv"

#	2.4.3, 2.4.5 causes a lot of ...
#	NameError: `@[]' is not allowed as an instance variable name
#    paperclip (2.4.5) lib/paperclip/options.rb:60:in `instance_variable_get'
#    paperclip (2.4.5) lib/paperclip/options.rb:60:in `method_missing'
gem "paperclip", '=2.4.2'	#	only used by buffler and clic

#	rarely used
gem "rdoc", "~>2"
gem "aws-s3"


gem "authlogic", "~> 2"
gem "ruby-hmac"
gem "rsolr", "=0.12.1"
gem "sunspot", "=1.2.1"
gem "sunspot_rails", "=1.2.1"


group :test do
	gem "ccls-html_test"
	gem "mocha", :require => false
	gem "autotest-rails", :require => 'autotest/rails'
	gem 'ZenTest', '~>4.5.0'
	gem "thoughtbot-factory_girl", :require => "factory_girl"
end


#
#	Everything seems to work with this ...
#
#	actionmailer (2.3.14)
#	actionpack (2.3.14)
#	activerecord (2.3.14)
#	activerecord-jdbc-adapter (1.2.2)
#	activerecord-jdbcmysql-adapter (1.2.2)
#	activerecord-jdbcsqlite3-adapter (1.2.2)
#	activeresource (2.3.14)
#	activesupport (2.3.14)
#	arel (2.0.2)
#	authlogic (2.1.6)
#	aws-s3 (0.6.2)
#	bouncy-castle-java (1.5.0146.1)
#	builder (3.0.0)
#	bundler (1.0.22)
#	ccls-calnet_authenticated (1.3.2)
#	ccls-common_lib (0.1.7)
#	ccls-simply_authorized (1.4.0)
#	chronic (0.6.6)
#	cocaine (0.2.1)
#	columnize (0.3.1)
#	escape (0.0.4)
#	fastercsv (1.5.4)
#	git (1.2.5)
#	haml (3.1.4)
#	hpricot (0.8.6 java)
#	i18n (0.6.0)
#	jdbc-mysql (5.1.13)
#	jdbc-sqlite3 (3.7.2)
#	jrails (0.6.0)
#	jruby-jars (1.6.5)
#	jruby-launcher (1.0.12 java)
#	jruby-openssl (0.7.5, 0.7.4)
#	jruby-rack (1.0.10)
#	json (1.6.5 java)
#	mime-types (1.17.2)
#	nokogiri (1.5.0 java)
#	paperclip (2.4.2)
#	pr_geohash (1.0.0)
#	rack (1.1.2)
#	rails (2.3.14)
#	rake (0.8.7)
#	rdoc (2.5.11)
#	RedCloth (4.2.7 java)
#	rsolr (0.12.1)
#	rspec (1.3.0)
#	ruby-debug (0.10.3)
#	ruby-debug-base (0.10.3.2 java)
#	ruby-hmac (0.4.0)
#	ruby-net-ldap (0.0.4)
#	rubycas-client (2.3.8)
#	rubygems-update (1.6.2)
#	rubyzip (0.9.6.1)
#	ryanb-acts-as-list (0.1.2)
#	sources (0.0.1)
#	ssl_requirement (0.1.0)
#	sunspot (1.2.1)
#	sunspot_rails (1.2.1)
#	ucb_ldap (1.4.2)
#	warbler (1.3.2)
#	will_paginate (2.3.16)
#	xml-simple (1.1.1)



#	20120412 ...
#	actionmailer (2.3.14)
#	actionpack (2.3.14)
#	activerecord (2.3.14)
#	activerecord-jdbc-adapter (1.2.2)
#	activerecord-jdbcmysql-adapter (1.2.2)
#	activerecord-jdbcsqlite3-adapter (1.2.2)
#	activeresource (2.3.14)
#	activesupport (2.3.14)
#	arel (2.0.2)
#	authlogic (2.1.6)
#	autotest-rails (4.1.2)
#	aws-s3 (0.6.2)
#	bouncy-castle-java (1.5.0146.1)
#	builder (3.0.0)
#	bundler (1.0.22)
#	ccls-html_test (0.3.0)
#	chronic (0.6.6)
#	cocaine (0.2.1)
#	columnize (0.3.1)
#	escape (0.0.4)
#	fastercsv (1.5.4)
#	git (1.2.5)
#	haml (3.1.4)
#	hpricot (0.8.6 java)
#	i18n (0.6.0)
#	jdbc-mysql (5.1.13)
#	jdbc-sqlite3 (3.7.2)
#	jrails (0.6.0)
#	jruby-jars (1.6.5)
#	jruby-launcher (1.0.12 java)
#	jruby-openssl (0.7.6.1, 0.7.5, 0.7.4)
#	jruby-rack (1.0.10)
#	json (1.6.5 java)
#	metaclass (0.0.1)
#	mime-types (1.18, 1.17.2)
#	mocha (0.10.5)
#	nokogiri (1.5.2 java, 1.5.0 java)
#	paperclip (2.4.2)
#	pr_geohash (1.0.0)
#	rack (1.1.2)
#	rails (2.3.14)
#	rake (0.8.7)
#	rdoc (2.5.11)
#	RedCloth (4.2.7 java)
#	rsolr (0.12.1)
#	rspec (1.3.0)
#	ruby-debug (0.10.3)
#	ruby-debug-base (0.10.3.2 java)
#	ruby-hmac (0.4.0)
#	ruby-net-ldap (0.0.4)
#	rubycas-client (2.3.8)
#	rubygems-update (1.6.2)
#	rubyzip (0.9.7, 0.9.6.1)
#	ryanb-acts-as-list (0.1.2)
#	sources (0.0.1)
#	ssl_requirement (0.1.0)
#	sunspot (1.2.1)
#	sunspot_rails (1.2.1)
#	thoughtbot-factory_girl (1.2.2)
#	ucb_ldap (1.4.2)
#	warbler (1.3.5, 1.3.2)
#	will_paginate (2.3.16)
#	xml-simple (1.1.1)
#	ZenTest (4.5.0)
