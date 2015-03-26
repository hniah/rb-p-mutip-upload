class UsersController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
		@users = User.all
		@user = User.new()
	end
	def new
		@users = User.all
		@user = User.new()
	end

	def create
		@user = User.new(get_param)
		respond_to do |format|
			if @user.save
				format.html { redirect_to @user, notice: 'User was Successfully Created.'}
				format.js{}
				# format.json { render json: @user, status: :created, location: @user }
			else
				format.html { render action: "new" }
				format.json { render json: @user.errors, status: :unprocessable_entity}
			end
		end

	end

	private
	def get_param
		params.require(:user).permit(:username, :avatar)
	end
end
