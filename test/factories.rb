Factory.define :user do |f|
	f.sequence(:username) { |n| "username#{n}" }
	f.sequence(:email) { |n| "username#{n}@example.com" }
	f.password 'V@1!dP@55w0rd'
	f.password_confirmation 'V@1!dP@55w0rd'
	f.email_confirmed_at Time.now
#	f.role_name 'user'
end

Factory.define :group do |f|
	f.sequence(:name) { |n| "Name#{n}" }
end

Factory.define :forum do |f|
	f.association :group
	f.sequence(:name) { |n| "Name#{n}" }
end

Factory.define :topic do |f|
	f.association :forum
	f.association :user
	f.sequence(:title) { |n| "Title#{n}" }
end

Factory.define :post do |f|
	f.association :topic
	f.association :user
	f.sequence(:body) { |n| "Body #{n}" }
end

Factory.define :group_role do |f|
	f.sequence(:name) { |n| "name#{n}" }
end

Factory.define :membership do |f|
	f.association :user
	f.association :group
#	f.association :group_role
	f.updated_at Time.now	#	to make it dirty
end

Factory.define :document do |f|
	f.sequence(:title) { |n| "Title#{n}" }
#	f.sequence(:document_file_name) { |n| "document_file_name#{n}" }
end

Factory.define :announcement do |f|
	f.association :user
	f.sequence(:title) { |n| "Title#{n}" }
	f.content "Some announcement content"
end
Factory.define :group_announcement, :parent => :announcement do |f|
	f.association :group
end
Factory.define :event do |f|
	f.association :user
	f.sequence(:title) { |n| "Title#{n}" }
	f.content "Some event content"
	f.begins_on Chronic.parse('tomorrow')
end
Factory.define :group_event, :parent => :event do |f|
	f.association :group
end
Factory.define :group_document do |f|
	f.association :user
	f.association :group
	f.sequence(:title) { |n| "Title#{n}" }
end
