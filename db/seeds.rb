# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def add_user_and_friends(access_token)
	graph = Koala::Facebook::API.new(access_token)
	friends = graph.get_connections("me","friends")
	original_user_profile = graph.get_object("me")

	#create the user who is inputting the data
	original_user = User.create(name: original_user_profile["name"], facebook_id: original_user_profile["id"], at_party: true)

	#add users friends as friendships
	friends.each do |f|
		user = User.find_or_create_by_facebook_id(name: f["name"], facebook_id: f["id"])
		original_user.friendships.create(friend: user.id)
	end	
end

# this method looks at the other users in the system and their friends and inputs mutual friendships
def create_mutual_friendships

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

#alexs friends
add_user_and_friends(ENV["ALEX_FACEBOOK_ACCESS_TOKEN"])
#charlottes friends
add_user_and_friends(ENV["CHARLOTTE_FACEBOOK_ACCESS_TOKEN"])

create_mutual_friendships


