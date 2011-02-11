#	From `script/generate simply_photos` ...
unless Gem.source_index.find_name('jakewendt-simply_photos').empty?
	gem 'jakewendt-simply_photos'
	require 'simply_photos/test_tasks'
end
