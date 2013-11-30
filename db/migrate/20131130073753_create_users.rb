class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :facebook_id
      t.boolean :at_party

      t.timestamps
    end
  end
end
