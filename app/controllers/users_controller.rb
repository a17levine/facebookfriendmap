class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
		@graph = Graph.find(params[:graph_id])
		@mutual_friendships = @user.mutual_friendships
	end

	def index
		@graph = Graph.find(params[:graph_id])
		@all_guests = @graph.users
	end
end
