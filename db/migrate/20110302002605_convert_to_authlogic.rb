class ConvertToAuthlogic < ActiveRecord::Migration
	def self.up
		drop_table :users
		create_table :users do |t|
			t.string    :username,            :null => false
			t.string    :email,               :null => false
			t.string    :crypted_password,    :null => false
			t.string    :password_salt,       :null => false
			t.string    :persistence_token,   :null => false
			t.string    :single_access_token, :null => false
			t.string    :perishable_token,    :null => false

			# Magic columns, just like ActiveRecord's created_at and updated_at. 
			# These are automatically maintained by Authlogic if they are present.
			t.integer   :login_count,         :null => false, :default => 0
			t.integer   :failed_login_count,  :null => false, :default => 0
			t.datetime  :last_request_at
			t.datetime  :current_login_at
			t.datetime  :last_login_at
			t.string    :current_login_ip
			t.string    :last_login_ip
			t.timestamps
		end
		add_index :users, :username, :unique => true
		add_index :users, :email, :unique => true
		add_index :users, :persistence_token, :unique => true
		add_index :users, :perishable_token, :unique => true
	end

	def self.down
		drop_table :users
		table_name = 'users'
		create_table table_name do |t|
			t.string :uid
			t.string :sn
			t.string :displayname
			t.string :mail, :default => '', :null => false
			t.string :telephonenumber
			t.timestamps
		end unless table_exists?(table_name)

		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :uid, :unique => true
			) unless idxs.include?("index_#{table_name}_on_uid")
		add_index( table_name, :sn
			) unless idxs.include?("index_#{table_name}_on_sn")
	end
end
