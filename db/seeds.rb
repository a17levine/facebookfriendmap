# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@graph = Koala::Facebook::API.new("CAACEdEose0cBALxBmFhYuSzgjP0dz3nnZA6dXr6lat9tSeTx6DUZB85Eccng4hPyHMrd5nA5QCodfMQsj2FT7pAmTHAFvkk9ya4RKCS2ztKPL0aPCYXRcdZCbb1knD6Tj5RoSqZA3eZCnq6CIzHa20Cj1BKfMZCApbH8jpZC3DQptJVEWYQuClZAaf5r87Bq2m0ZD")
friends = @graph.get_connections("me","friends")
original_user_profile = @graph.get_object("me")

#create the user who is inputting the data
original_user = User.create(name: original_user_profile["name"], facebook_id: original_user_profile["id"])

#add users friends as friendships
friends.each do |f|
	user = User.create(name: f["name"], facebook_id: f["id"])
	original_user.friendships.create(friend: user.id)
end