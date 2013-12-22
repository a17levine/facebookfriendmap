class AddGraphIdToEntrances < ActiveRecord::Migration
  def change
    add_column :entrances, :graph_id, :integer
  end
end
