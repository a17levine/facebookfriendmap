class User < ActiveRecord::Base
	has_many :friendships

	def translate_to_node_hash
		node_hash = {}
		node_hash["name"] = self.name
		node_hash["group"] = 1
		node_hash["facebook_photo"] = self.facebook_pic_small
		return node_hash
	end

	def self.at_party
		User.where(at_party:true)
	end

	def self.add_guest_and_process(access_token)
		Entrance.add_user_and_friends(access_token)
		Entrance.create_mutual_friendships
		Entrance.create_graph
	end
end
