class EntrancesController < ApplicationController
	def new
		@entrance = Entrance.new
	end
end
