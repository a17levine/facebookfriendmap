class Graph < ActiveRecord::Base
	has_many :attendees
	has_many :users, through: :attendees



  def create_graph
    graph_ruby_hash = {}
    graph_ruby_hash["links"] = []
    graph_ruby_hash["nodes"] = []

    unique_mutual_friendships = Set.new
    
    MutualFriendship.all.each do |mf|
      pair = [mf.user_at_party, mf.user_at_party_2]
      unique_mutual_friendships << pair
    end
    
    unique_users_at_party = self.users.map {|u| u.id}

    # create all links. pairs in the following function will look
    # like [32,456] so pair[0] and pair[1] will be used
    unique_mutual_friendships.each do |pair|
      mutual_friend_count = MutualFriendship.find_all_by_user_at_party(pair[0], :conditions => "user_at_party_2 = #{pair[1]}").count
      graph_ruby_hash["links"] << {"source" => unique_users_at_party.index(pair[0]), "target"=> unique_users_at_party.index(pair[1]), "value" => mutual_friend_count}
    end

    # add user nodes

    unique_users_at_party.each do |unique_user_id|
      graph_ruby_hash["nodes"]  << User.find(unique_user_id).translate_to_node_hash
    end

    File.open("public/graphs/#{self.id}/data.json", 'w') {|f| f.write(graph_ruby_hash.to_json) }
    return graph_ruby_hash
  end

end
