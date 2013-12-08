class Entrance < ActiveRecord::Base

	def self.add_user_and_friends(access_token)
		graph = Koala::Facebook::API.new(access_token)
		friends = graph.get_connections("me","friends")
		original_user_profile = graph.get_object("me")

		#create the user who is inputting the data
		original_user = User.create(name: original_user_profile["name"], 
																facebook_id: original_user_profile["id"], 
																at_party: true,
																facebook_pic_small: graph.get_picture(original_user_profile["id"]))

		#add users friends as friendships
		friends.each do |f|
			user = User.find_or_create_by_facebook_id(name: f["name"], facebook_id: f["id"])
			original_user.friendships.create(friend: user.id)
		end	

	end

	def self.create_mutual_friendships

		# this goes through and finds all the unique combinations between the users at the party
		partygoers_ids = User.where(at_party: true).map { |u| u.id }
		combinations_of_partygoers = (0...(partygoers_ids.size-1)).inject([]) {|pairs,x| pairs += ((x+1)...partygoers_ids.size).map {|y| [partygoers_ids[x],partygoers_ids[y]]}}

		# with those combinations of partygoers, we iterate through to find their friends and mutual ones
		combinations_of_partygoers.each do |combo|
			first_partygoer = combo[0]
			first_partygoer_friends_array = User.find(first_partygoer).friendships.map {|f| f.friend}
			second_partygoer = combo[1]
			second_partygoer_friends_array = User.find(second_partygoer).friendships.map {|f| f.friend}

			#this finds mutual friends 
			mutual_friends_array = first_partygoer_friends_array & second_partygoer_friends_array

			mutual_friends_array.each do |mf|
				MutualFriendship.create(user_at_party: first_partygoer, user_at_party_2: second_partygoer, mutual_friend: mf)
			end
		end
	end

	def self.create_graph
		graph_ruby_hash = {}
		graph_ruby_hash["links"] = []
		graph_ruby_hash["nodes"] = []

		unique_mutual_friendships = Set.new
		
		MutualFriendship.all.each do |mf|
			pair = [mf.user_at_party, mf.user_at_party_2]
			unique_mutual_friendships << pair
		end
		
		unique_users_at_party = Set.new
		User.at_party.each {|user| unique_users_at_party << user.id }
		unique_users_at_party = unique_users_at_party.to_a

		# create all links. pairs in the following function will look
		# like [32,456] so pair[0] and pair[1] will be used
		unique_mutual_friendships.each do |pair|
			mutual_friend_count = MutualFriendship.find_all_by_user_at_party(pair[0], :conditions => "user_at_party_2 = #{pair[1]}").count
			graph_ruby_hash["links"] << {"source" => unique_users_at_party.index(pair[0]), "target"=> unique_users_at_party.index(pair[1]), "value" => mutual_friend_count}
		end

		# add user nodes

		unique_users_at_party.each do |unique_user_id|
		graph_ruby_hash["nodes"]	<< User.find(unique_user_id).translate_to_node_hash
		end
		File.open("public/graph.json", 'w') {|f| f.write(graph_ruby_hash.to_json) }
		return graph_ruby_hash
	end

	def send_sms_for_user_page
			
	end

end
