# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110824215431) do

  create_table "annual_meetings", :force => true do |t|
    t.string   "meeting"
    t.text     "abstract"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "annual_meetings", ["meeting"], :name => "index_annual_meetings_on_meeting"

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "doc_forms", :force => true do |t|
    t.string   "title"
    t.text     "abstract"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doc_forms", ["title"], :name => "index_doc_forms_on_title"

  create_table "documents", :force => true do |t|
    t.integer  "owner_id"
    t.string   "title",                                    :null => false
    t.text     "abstract"
    t.boolean  "shared_with_all",       :default => false, :null => false
    t.boolean  "shared_with_select",    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "owner_type"
  end

  add_index "documents", ["document_file_name"], :name => "index_documents_on_document_file_name", :unique => true
  add_index "documents", ["owner_id", "owner_type"], :name => "index_documents_on_owner_id_and_owner_type"

  create_table "events", :force => true do |t|
    t.string   "title",              :null => false
    t.text     "content",            :null => false
    t.integer  "user_id",            :null => false
    t.integer  "group_id"
    t.date     "begins_on"
    t.date     "ends_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.integer  "begins_at_hour"
    t.integer  "begins_at_minute"
    t.string   "begins_at_meridiem"
    t.integer  "ends_at_hour"
    t.integer  "ends_at_minute"
    t.string   "ends_at_meridiem"
  end

  create_table "exposures", :force => true do |t|
    t.integer  "study_id"
    t.string   "category"
    t.string   "relation_to_child"
    t.text     "windows"
    t.text     "types"
    t.text     "assessments"
    t.text     "forms_of_contact"
    t.text     "locations_of_use"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", :force => true do |t|
    t.integer  "group_id"
    t.string   "name",                        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count", :default => 0
    t.integer  "posts_count",  :default => 0
  end

  add_index "forums", ["group_id", "name"], :name => "index_forums_on_group_id_and_name", :unique => true
  add_index "forums", ["group_id"], :name => "index_forums_on_group_id"

  create_table "group_documents", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id",                                   :null => false
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.integer  "attachable_id"
    t.string   "attachable_type",       :default => "Post"
  end

  create_table "group_roles", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name",                        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "parent_id"
    t.integer  "groups_count", :default => 0
  end

  add_index "groups", ["name"], :name => "index_groups_on_name", :unique => true

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "group_role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",      :default => false
  end

  create_table "pages", :force => true do |t|
    t.integer  "position"
    t.integer  "parent_id"
    t.boolean  "hide_menu",  :default => false
    t.string   "path"
    t.string   "title_en"
    t.string   "title_es"
    t.string   "menu_en"
    t.string   "menu_es"
    t.text     "body_en"
    t.text     "body_es"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
  add_index "pages", ["path"], :name => "index_pages_on_path", :unique => true

  create_table "photos", :force => true do |t|
    t.string   "title",              :null => false
    t.text     "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "topic_id",   :null => false
    t.text     "body",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["topic_id"], :name => "index_posts_on_topic_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "professions", :force => true do |t|
    t.integer  "position"
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "professions", ["name"], :name => "index_professions_on_name", :unique => true

  create_table "publication_publication_subjects", :force => true do |t|
    t.integer  "publication_id",         :null => false
    t.integer  "publication_subject_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publication_studies", :force => true do |t|
    t.integer  "publication_id", :null => false
    t.integer  "study_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publication_subjects", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publication_subjects", ["name"], :name => "index_publication_subjects_on_name"

  create_table "publications", :force => true do |t|
    t.integer  "publication_subject_id"
    t.integer  "study_id"
    t.string   "author_last_name"
    t.integer  "publication_year",          :limit => 255
    t.string   "journal"
    t.string   "title"
    t.string   "other_publication_subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publications", ["publication_subject_id"], :name => "index_publications_on_publication_subject_id"
  add_index "publications", ["study_id"], :name => "index_publications_on_study_id"

  create_table "roles", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "studies", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "world_region"
    t.string   "country"
    t.string   "design"
    t.string   "recruitment"
    t.string   "target_age_group"
    t.text     "principal_investigators"
    t.text     "overview"
  end

  add_index "studies", ["name"], :name => "index_studies_on_name"

  create_table "subjects", :force => true do |t|
    t.integer  "study_id"
    t.string   "clic_id"
    t.string   "case_control"
    t.string   "leukemiatype"
    t.string   "immunophenotype"
    t.string   "interview_respondent"
    t.integer  "reference_year"
    t.integer  "birth_year"
    t.string   "gender"
    t.integer  "age"
    t.string   "ethnicity"
    t.integer  "mother_age_birth"
    t.integer  "father_age_birth"
    t.string   "income_quint"
    t.string   "downs"
    t.string   "mother_education"
    t.string   "father_education"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.integer  "forum_id",                   :null => false
    t.string   "title",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "posts_count", :default => 0
  end

  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"

  create_table "user_professions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "profession_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                                 :null => false
    t.string   "email",                                    :null => false
    t.string   "crypted_password",                         :null => false
    t.string   "password_salt",                            :null => false
    t.string   "persistence_token",                        :null => false
    t.string   "single_access_token",                      :null => false
    t.string   "perishable_token",                         :null => false
    t.integer  "login_count",           :default => 0,     :null => false
    t.integer  "failed_login_count",    :default => 0,     :null => false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "old_email"
    t.datetime "email_confirmed_at"
    t.integer  "topics_count",          :default => 0
    t.integer  "posts_count",           :default => 0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "degrees"
    t.string   "title"
    t.string   "profession"
    t.string   "organization"
    t.text     "address"
    t.string   "phone_number"
    t.text     "research_interests"
    t.text     "selected_publications"
    t.boolean  "approved",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
