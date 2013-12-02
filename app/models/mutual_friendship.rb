class MutualFriendship < ActiveRecord::Base
	def self.create_data_json
		#create nodes and links in a JSON file
		hash = {
			"nodes" => [{
				"name" => "test",
				"group" => 1,
				"facebook_id" => 55
				}],
			"links" => [{
				"source"=>1,
				"target"=>0,
				"value"=>5
				}]
		}
		hash.to_json
	end
end
