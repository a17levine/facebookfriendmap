class Graph < ActiveRecord::Base
	def attendees
		entrances_for_graph = Entrance.where(:graph_id => self.id)
		partygoers_aka_users_for_graph = entrances_for_graph.map do {|e| User.find(e.user_id)}
		unique_partygoers_aka_users_for_graph = partygoers_aka_users_for_graph.uniq
		return unique_partygoers_aka_users_for_graph
	end
end
