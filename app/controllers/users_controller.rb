class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
		@mutual_friendships = @user.mutual_friendships
	end
end
