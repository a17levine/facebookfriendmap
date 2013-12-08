class MutualFriendship < ActiveRecord::Base
	
	# input all of the guests at the party
	# input all mutual friendship objects

	def self.create_data_json

		# mutual_friendships = MutualFriendship.all
		# users_with_mutual_friends = Set.new


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
