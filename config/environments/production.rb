# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store
#config.cache_store = :file_store, 'tmp/cache'

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

config.action_mailer.delivery_method = :smtp

config.action_mailer.default_url_options = { 
	:host => "ccls.berkeley.edu" }

#
#	Although clic is in the same place as Buffler and Homex,
#	it is only hosted there and proxied through
#	clic.berkeley.edu now so the relative_url_root
#	can be left blank (NOT nil however)
#
#	Nobody seems to care that I commented this out,
#	suggesting that the rails app itself or tomcat
#	is telling it that it is in '/clic'
#
#	config.action_controller.relative_url_root = '/clic'
