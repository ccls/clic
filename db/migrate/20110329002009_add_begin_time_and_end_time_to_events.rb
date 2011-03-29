class AddBeginTimeAndEndTimeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :begin_time, :string
    add_column :events, :end_time, :string
  end

  def self.down
    remove_column :events, :end_time
    remove_column :events, :begin_time
  end
end
