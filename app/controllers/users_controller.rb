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
		@all_guests = Graph.find(params[:graph_id]).users
	end
end
