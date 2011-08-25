
Factory.define :annual_meeting do |f|
	f.sequence(:meeting) { |n| "Meeting #{n}" }
	f.sequence(:abstract) { |n| "Abstract #{n}" }
end

Factory.define :document do |f|
	f.sequence(:title) { |n| "Document Title #{n}" }
#	f.sequence(:document_file_name) { |n| "document_file_name#{n}" }
end

Factory.define :doc_form do |f|
	f.sequence(:title) { |n| "Title #{n}" }
	f.sequence(:abstract) { |n| "Abstract #{n}" }
end

Factory.define :event do |f|
	f.association :user
	f.sequence(:title) { |n| "Event Title #{n}" }
	f.content "Some event content"
	f.begins_on Chronic.parse('Dec 5, 1971').to_date
end
Factory.define :group_event, :parent => :event do |f|
	f.association :group
end

Factory.define :forum do |f|
#	f.association :group
	f.sequence(:name) { |n| "Forum #{n}" }
end

Factory.define :group do |f|
	f.sequence(:name) { |n| "Group #{n}" }
end

Factory.define :group_document do |f|
#	f.association :post
	f.association :attachable, :factory => :post
	f.association :user
#	f.association :group
	f.sequence(:title) { |n| "Group Document Title #{n}" }
end

Factory.define :group_role do |f|
	f.sequence(:name) { |n| "Group Role #{n}" }
end

Factory.define :membership do |f|
	f.association :user
	f.association :group
#	f.association :group_role
	f.updated_at Time.now	#	to make it dirty
end

Factory.define :post do |f|
	f.association :topic
	f.association :user
	f.sequence(:body) { |n| "Post Body #{n}" }
end

Factory.define :profession do |f|
	f.sequence(:name) { |n| "Name #{n}" }
end

Factory.define :publication do |f|
#	f.association :study
#	f.association :publication_subject
	f.sequence(:title) { |n| "Title #{n}" }
	f.sequence(:journal) { |n| "Journal #{n}" }

#	TODO publication_year will now be an integer
#	f.sequence(:publication_year) { |n| "Publication Year #{n}" }
	f.publication_year Time.now.year
	f.sequence(:author_last_name) { |n| "Author Last Name #{n}" }
	f.study_ids {|p| [Factory(:study).id] }
	f.publication_subject_ids {|p| [Factory(:publication_subject).id] }
end

Factory.define :publication_subject do |f|
	f.sequence(:name) { |n| "Name #{n}" }
end
Factory.define :publication_publication_subject do |f|
	f.association :publication
	f.association :publication_subject
#	f.updated_at Time.now	#	to make it dirty
end

Factory.define :publication_study do |f|
	f.association :publication
	f.association :study
#	f.updated_at Time.now	#	to make it dirty
end

Factory.define :study do |f|
	f.sequence(:name) { |n| "Name #{n}" }
end

Factory.define :topic do |f|
	f.association :forum
	f.association :user
	f.sequence(:title) { |n| "Topic Title #{n}" }
end

Factory.define :user do |f|
	f.sequence(:username) { |n| "username#{n}" }
	f.sequence(:email) { |n| "username#{n}@example.com" }
	f.password 'V@1!dP@55w0rd'
	f.password_confirmation 'V@1!dP@55w0rd'
	f.email_confirmed_at Time.now
#	f.role_name 'user'
	f.first_name "First"
	f.last_name "Last"
	f.degrees "Degrees"
	f.title "Title"
#	f.profession "Profession"
	f.organization "Organization"
	f.address "Address"
	f.phone_number "PhoneNumber"
#	f.profession_ids [Profession.random.id]	#	usually works
#	f.professions {|p| [p.association(:profession)] }	#	seems to make everyone happy, well most
#	f.profession_ids {|p| [p.association(:profession).id] }	#	seems to make everyone happy, well most
	f.profession_ids {|p| [Factory(:profession).id] }	#	seems to make everyone happy, well most
#	after_build {|u| u.professions << Factory(:profession) }	#	nope
end
Factory.define :user_profession do |f|
	f.association :user
	f.association :profession
#	f.updated_at Time.now	#	to make it dirty
end


Factory.define :subject do |f|
end
Factory.define :exposure do |f|
end
