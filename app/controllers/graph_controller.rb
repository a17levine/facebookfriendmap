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

	def entrance
		puts params
	end
end
