class AddUserIdtoEntrances < ActiveRecord::Migration
  def change
  	add_column :entrances, :user_id, :integer
  end
end
