class CreateMutualFriendships < ActiveRecord::Migration
  def change
    create_table :mutual_friendships do |t|
      t.integer :user_at_party
      t.integer :user_at_party_2
      t.integer :mutual_friend

      t.timestamps
    end
  end
end
