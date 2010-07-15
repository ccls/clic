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
