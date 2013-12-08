class CreateEntrances < ActiveRecord::Migration
  def change
    create_table :entrances do |t|
      t.string :phone
      t.string :facebook_token
      t.string :user_name

      t.timestamps
    end
  end
end
