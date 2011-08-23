namespace :app do

	desc "Load some fixtures to database for application"
	task :setup => :environment do
#		fixtures = []
#		fixtures.push('pages')
#		fixtures.push('roles')
#		fixtures.push('group_roles')
#		fixtures.push('groups')
#		fixtures.push('forums')
#		fixtures.push('photos')
#		fixtures.push('documents')
#		fixtures.push('publication_subjects')
#		fixtures.push('studies')
#		ENV['FIXTURES'] = fixtures.join(',')
#		puts "Loading fixtures for #{ENV['FIXTURES']}"
#		Rake::Task["db:fixtures:load"].invoke

#		%w(
#			1CLIC_2009timelinefullproposal_033109.pdf
#			2CLICEOIForm_030109.pdf
#			3CLICAPAForm_030109.pdf
#			CLIC2006MeetingMaterials.pdf
#			CLIC2007MeetingMaterials.pdf
#			CLIC2008MeetingMaterials.pdf
#			CLICAuthorshipPolicy_020810.pdf
#			CLICMembershipGuidelinesFinal_030309.pdf
#			R01CollabTable062807FINAL.pdf
#		).each do |document|
#			Document.create(:title => document,
#				:document => File.open(File.join(RAILS_ROOT,'to_upload',document)))
#		end

#		%w( CLICOrgChart_March09_000.jpg).each do |photo|
#			Photo.create(:title => photo,
#				:image => File.open(File.join(RAILS_ROOT,'to_upload',photo)))
#		end

	end


	desc "Add user by username"
	task :add_user => :environment do
		puts
		if ENV['username'].blank?
			puts "Username required."
			puts "Usage: rake #{$*} username=STRING"
			puts
			exit
		end
		if !User.exists?(:username => ENV['username'])
			puts "No user found with username=#{ENV['username']}. Adding..."
			User.create({
				:username => ENV['username'],
				:password => ENV['username'],
				:password_confirmation => ENV['username'],
				:email => "#{ENV['username']}@berkeley.edu",
			})
		else
			puts "User with username #{ENV['username']} already exists."
		end
		puts
	end

	desc "Deputize user by username"
	task :deputize => :environment do
		puts
		if ENV['username'].blank?
			puts "Username required."
			puts "Usage: rake #{$*} username=STRING"
			puts
			exit
		end
		if !User.exists?(:username => ENV['username'])
			puts "No user found with username=#{ENV['username']}."
			puts
			exit
		end
		user = User.find(:first, :conditions => { :username => ENV['username'] })
		puts "Found user #{user.username}.  Deputizing..."
		user.deputize
		puts "User deputized: #{user.is_administrator?}"
		puts
	end


	task :convert_announcements_to_events => :environment do
		puts "Converting all announcements to events."
		jake = User.find_by_email('jakewendt@berkeley.edu')
		Announcement.all.each do |a|
			puts "Converting #{a} to event."
			puts "Group: #{a.group}"
			e = if a.group
				a.group.events.new(a.attributes)
			else
				Event.new(a.attributes)
			end
			#	user is protected so must explicitly assign
			e.user = a.user || jake
#			puts e.inspect
#			puts e.errors.inspect unless e.valid?
			e.save!
		end
	end


	#	convenience tasks for when I misremember the order
	namespace :import do
		task :exposures => "app:exposures:import"
		task :subjects => "app:subjects:import"
	end

end
