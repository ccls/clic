source "http://rubygems.org"

gem 'rails', '~> 4.0'	#	without a version, it installed rails 0.9.6!
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

gem "authlogic"
gem "ruby-hmac"

gem 'minitest'

group :test do
	gem "jakewendt-html_test"

	gem "simplecov", :require => false

	gem 'test-unit'

	gem "mocha", :require => false

	gem "autotest-rails", :require => 'autotest/rails'

	gem 'ZenTest'	#, '=4.9.1'

	gem "factory_girl_rails"
	gem "jakewendt-test_with_verbosity"


	#	the latest capybara seems to install just fine when the latest xcode and command line tools are.
	#	NOTE however, the "find field" seems to always fail?
	#
	#	newer capybara not compatible with current webkit
	#	need to explicitly have capybara for the version or
	#	it will by upgraded to 2.1.0 which fails
	gem 'capybara', '~> 2.0.0'
	#	capybara-webkit 1.0.0 bombs big time compiling native code
	gem 'capybara-webkit', '~> 0.14'

	#	After rails 4, upgraded capybara stuff, but still had issues finding fields
	#	capybara (2.2.1)
	#	capybara-webkit (1.1.0)

	#	for dealing with integration tests
	gem 'database_cleaner'




end

gem "ccls-common_lib", ">0.9"

