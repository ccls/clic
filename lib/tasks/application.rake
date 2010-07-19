namespace :app do

#	task :args_as_array do
#		args = $*.dup.slice(1..-1)
#		puts args.collect {|arg| "X:" << arg }.join("\n")
#		exit
#	end

	desc "Load some fixtures to database for application"
	task :setup => :environment do
		fixtures = []
		fixtures.push('pages')
		fixtures.push('roles')
		ENV['FIXTURES'] = fixtures.join(',')
		puts "Loading fixtures for #{ENV['FIXTURES']}"
		Rake::Task["db:fixtures:load"].invoke
		Rake::Task["app:add_users"].invoke
		ENV['uid'] = '859908'
		Rake::Task["app:deputize"].invoke
		ENV['uid'] = '228181'
		Rake::Task["app:deputize"].reenable	#	<- this is stupid!
		Rake::Task["app:deputize"].invoke

		%w(
		1CLIC_2009timelinefullproposal_033109.pdf
		2CLICEOIForm_030109.pdf
		3CLICAPAForm_030109.pdf
		CLICAuthorshipPolicy_020810.pdf
		CLICMembershipGuidelinesFinal_030309.pdf
		R01CollabTable062807FINAL.pdf 
		).each do |document|
			Document.create(:title => document,
				:document => File.open(File.join(RAILS_ROOT,'to_upload',document)))
		end

		%w( CLICOrgChart_March09_000.jpg).each do |photo|
			Photo.create(:title => photo,
				:image => File.open(File.join(RAILS_ROOT,'to_upload',photo)))
		end

	end

	desc "Add some expected users."
	task :add_users => :environment do
		puts "Adding users"
		%w( 859908 228181 855747 214766 180918 66458 808 768475 
			10883 86094 754783 769067 740176 315002 854720 16647 ).each do |uid|
			puts " - Adding user with uid:#{uid}:"
			User.find_create_and_update_by_uid(uid)
		end
	end

	desc "Deputize user by UID"
	task :deputize => :environment do
		puts
		if ENV['uid'].blank?
			puts "User's CalNet UID required."
			puts "Usage: rake #{$*} uid=INTEGER"
			puts
			exit
		end
		if !User.exists?(:uid => ENV['uid'])
			puts "No user found with uid=#{ENV['uid']}."
			puts
			exit
		end
		user = User.find(:first, :conditions => { :uid => ENV['uid'] })
		puts "Found user #{user.displayname}.  Deputizing..."
		user.deputize
		puts "User deputized: #{user.administrator?}"
		puts
	end

end
