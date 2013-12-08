class AddFacebookPicSmallToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_pic_small, :string
  end
end
