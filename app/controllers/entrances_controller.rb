class EntrancesController < ApplicationController
	def new
		@entrance = Entrance.new
		@graph = Graph.find(params[:graph_id])
	end

	def create
		@entrance = Entrance.new(entrances_params)
		@entrance.graph_id = params[:graph_id]
		if @entrance.save
			redirect_to graph_path(params[:graph_id])	
		end
	end

	private

  def entrances_params
    params.require(:entrance).permit(:phone, :facebook_token, :graph_id)
  end
end
