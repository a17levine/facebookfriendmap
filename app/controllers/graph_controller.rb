class GraphController < ApplicationController
	def index
		@all_graphs = Graph.all
	end

	def welcome
		
	end

	def show
		#this is where the graph loads
		@graph = Graph.find(params[:id])
		
		if Entrance.where(:graph_id => params[:id]).any?
			@graph_json = JSON.parse( IO.read("public/graphs/#{params[:id]}/data.json") )
			
			respond_to do |format|
			  format.html
			  format.json { render :json => @graph_json, layout: false }
			end
		else
			@graph_json = {}
			respond_to do |format|
			  format.html
			  format.json { render :json => @graph_json, layout: false }
			end
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
