class GraphController < ApplicationController
	def index
		@all_graphs = Graph.all
	end

	def welcome
		
	end

	def show
		#this is where the graph loads
		@graph = Graph.find(params[:id])
		@graph_json = Entrance.create_graph

		respond_to do |format|
		  format.html # index.html.erb
		  format.json { render :json => @graph_json, layout: false }
		end
	end

	def new
		@graph = Graph.new
	end

	def create
		@graph = Graph.new(graph_params)
		if @graph.save
			redirect_to graph_index_path
		else
			errors.add("Something went wrong creating this graph")
		end
	end

	def destroy
		@graph = Graph.find(params[:id])
		@graph.delete
		redirect_to graph_index_path
	end

	def entrance
		puts params
	end

	private

	def graph_params
    params.require(:graph).permit(:name)
  end
end
