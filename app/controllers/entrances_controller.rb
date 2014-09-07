class EntrancesController < ApplicationController
	def new
		@entrance = Entrance.new
		@graph = Graph.new
		@graph.id = 1
	end

	def create
		@entrance = Entrance.new(entrances_params)
		@entrance.graph_id = params[:graph_id]
		if @entrance.save
			redirect_to graph_path(params[:graph_id])
		end
		render nothing: true
	end

	private

  def entrances_params
    params.require(:entrance).permit(:phone, :facebook_token, :graph_id)
  end
end
