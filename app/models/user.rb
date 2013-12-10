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


	# returns MutualFriendship objects which include user

	def mutual_friendships_ids
		all_mutual_friendships = MutualFriendship.where("user_at_party = ? OR user_at_party_2 = ?", self.id, self.id)
		all_mutual_friends_ids = Set.new
		all_mutual_friendships.each do |mf|
			if mf.user_at_party == self.id
				all_mutual_friends_ids << mf.user_at_party_2
			elsif mf.user_at_party_2 == self.id
				all_mutual_friends_ids << mf.user_at_party
			end
		end
		all_mutual_friends_ids
	end

	def mutual_friendships
		all_mutual_friends_ids = self.mutual_friendships_ids
		
		mutual_friendships_array =  all_mutual_friends_ids.map do |id|
			hash = {other_guest: User.find(id)}
			hash[:mutual_friends] = []
			unique_mutual_friends = Set.new	

			MutualFriendship.where("user_at_party = ? AND user_at_party_2 = ?", self.id, id).each do |mfobj|
				unique_mutual_friends << mfobj.mutual_friend
			end

			MutualFriendship.where("user_at_party = ? AND user_at_party_2 = ?", id, self.id).each do |mfobj|
				unique_mutual_friends << mfobj.mutual_friend
			end
			hash[:mutual_friends] = unique_mutual_friends.map {|umf| User.find(umf)}
			hash
		end
		mutual_friendships_array.sort_by! {|mf| mf[:mutual_friends].count}.reverse!
		mutual_friendships_array
	end

end
