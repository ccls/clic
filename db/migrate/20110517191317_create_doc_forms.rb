class CreateDocForms < ActiveRecord::Migration
  def self.up
    create_table :doc_forms do |t|
      t.string :title
      t.text :abstract
      t.timestamps
    end
		add_index :doc_forms, :title
  end

  def self.down
    drop_table :doc_forms
  end
end
