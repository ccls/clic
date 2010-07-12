require 'ucb_ccls_cms_plugin'


config.load_paths << File.join(File.dirname(__FILE__),'..','/app/sweepers')

config.gem "RedCloth"

config.action_view.sanitized_allowed_attributes = 'id', 'class', 'style'

config.reload_plugins = true if RAILS_ENV == 'development'

