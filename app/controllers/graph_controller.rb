class GraphController < ApplicationController
	def index
		#this is where the graph loads

		@graph = Entrance.create_graph

		respond_to do |format|
		  format.html # index.html.erb
		  format.json { render :json => @graph, layout: false }
		end
		
	end

	def welcome
		
	end

	def show
	end

	def entrance
		puts params
	end
end
