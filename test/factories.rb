
Factory.define :annual_meeting do |f|
	f.sequence(:meeting) { |n| "Meeting #{n}" }
	f.sequence(:abstract) { |n| "Abstract #{n}" }
end

Factory.define :document do |f|
	f.sequence(:title) { |n| "Document Title #{n}" }
end

Factory.define :doc_form do |f|
	f.sequence(:title) { |n| "Title #{n}" }
	f.sequence(:abstract) { |n| "Abstract #{n}" }
end

Factory.define :announcement do |f|
	f.association :user
	f.sequence(:title) { |n| "Announcement Title #{n}" }
	f.content "Some announcement content"
	f.begins_on Chronic.parse('Dec 5, 1971').to_date
end
Factory.define :group_announcement, :parent => :announcement do |f|
	f.association :group
end

Factory.define :exposure do |f|
end

Factory.define :forum do |f|
	f.sequence(:name) { |n| "Forum #{n}" }
end

Factory.define :group do |f|
	f.sequence(:name) { |n| "Group #{n}" }
end

Factory.define :group_document do |f|
	f.association :attachable, :factory => :post
	f.association :user
	f.sequence(:title) { |n| "Group Document Title #{n}" }
end

Factory.define :group_role do |f|
	f.sequence(:name) { |n| "Group Role #{n}" }
end

Factory.define :membership do |f|
	f.association :user
	f.association :group
	f.updated_at Time.now	#	to make it dirty
end

Factory.define :page do |f|
	f.sequence(:path) { |n| "/path#{n}" }
	f.sequence(:menu_en) { |n| "Menu #{n}" }
	f.sequence(:title_en){ |n| "Title #{n}" }
	f.body_en  "Page Body"
end

Factory.define :photo do |f|
	f.sequence(:title) { |n| "Title#{n}" }
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
	f.sequence(:title) { |n| "Title #{n}" }
	f.sequence(:journal) { |n| "Journal #{n}" }
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
end

Factory.define :publication_study do |f|
	f.association :publication
	f.association :study
end

Factory.define :questionnaire do |f|
	f.association :study
	f.sequence(:title) { |n| "Title #{n}" }
end

Factory.define :study do |f|
	f.sequence(:name) { |n| "Name #{n}" }
end

Factory.define :subject do |f|
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
	f.first_name "First"
	f.last_name "Last"
	f.degrees "Degrees"
	f.title "Title"
	f.organization "Organization"
	f.address "Address"
	f.phone_number "PhoneNumber"
	f.profession_ids {|p| [Factory(:profession).id] }
end

Factory.define :user_profession do |f|
	f.association :user
	f.association :profession
end
