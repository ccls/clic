class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title, :null => false
      t.text :content, :null => false
      t.integer :user_id, :null => false
      t.integer :group_id
      t.date :begins_on, :null => false
      t.date :ends_on
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
