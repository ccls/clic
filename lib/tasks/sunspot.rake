#	As the sunspot rake tasks do not automatically get included,
#	I did so manually.  I could have just copied the file here,
#	but if it changes in the gem, it wouldn't here.  So I search
#	for the latest gem and explicitly require it here.
if g = Gem.source_index.find_name('sunspot_rails').last
	require g.full_gem_path + '/lib/sunspot/rails/tasks.rb'
end
