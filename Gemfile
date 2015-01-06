source "http://rubygems.org"

gem 'rails'
gem 'protected_attributes'	#	to keep rails 3 style

gem 'sqlite3'

gem 'tinymce-rails'

gem "RedCloth"

gem "arel"

gem "chronic"

gem "hpricot"

gem 'rack-ssl', :require => 'rack/ssl'

gem "acts_as_list"

gem "will_paginate"

gem 'mysql'
gem 'mysql2'

gem "paperclip"

gem "rdoc"
gem "aws-s3"
gem 'aws-sdk'




#	don't know why I have to force the gem version, nevertheless
gem "authlogic", ">=3.4.4"






gem "bcrypt"	#	required by authlogic 3.4.1 even though I'm not using.  Lame.
gem "scrypt"	#	required by authlogic 3.4.1 even though I'm not using.  Lame.

gem "ruby-hmac"




#	minitest-5.3.4/lib/minitest.rb
#	still true in 5.4.0.  May need to just redefine the offending method.
#	test classes are purposely shuffled!  Only change in this version!  Why?
#	Random is stupid.  Unpredictable.  Poor testing strategy.
#	144: suites = Runnable.runnables.shuffle
#	remove this requirement if can find a way around
gem 'minitest', '= 5.3.3'



group :test do
	gem "jakewendt-html_test"

	gem "simplecov", :require => false

	gem 'test-unit'

	gem "mocha", :require => 'mocha/setup'	#, :require => false

	gem "autotest-rails", :require => 'autotest/rails'

	gem 'ZenTest'	#, '=4.9.1'

	gem "factory_girl_rails"
	gem "jakewendt-test_with_verbosity"


	gem 'capybara'
	gem 'capybara-webkit'

	#	for dealing with integration tests
	gem 'database_cleaner'

	#	extracted for rails 4.2.0
	gem 'rails-dom-testing'
end

gem "ccls-common_lib", ">0.9"

