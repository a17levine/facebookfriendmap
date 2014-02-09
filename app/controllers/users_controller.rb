class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
		@mutual_friendships = @user.mutual_friendships
	end

	def index
		@all_guests = User.where(:at_party => true)
	end
end
