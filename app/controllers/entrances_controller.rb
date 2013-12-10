class EntrancesController < ApplicationController
	def new
		@entrance = Entrance.new
		@graph = Graph.new
		@graph.id = 1
	end

	def create
		render nothing: true
		# binding.pry
	end
end
