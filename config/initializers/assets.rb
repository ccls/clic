# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )


Rails.application.config.assets.precompile += %w( 
	common_lib.js 
	common_lib.css

pages.js
photo.js
search_results.js
jquery.simplemodal.1.4.4.min.js
orderable.js

layout.css		
shared.css
page.css		
simple_modal_basic.css
calendar.css		
pages.css		
user.css
directory.css		
photo.css		
user_session.css
group.css		
publication.css		
users.css
ie.css			
reset.css		
inventory.css		
scaffold.css

)
