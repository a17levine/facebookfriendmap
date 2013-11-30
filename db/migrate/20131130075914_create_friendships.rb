class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :user, index: true
      t.integer :friend

      t.timestamps
    end
  end
end
