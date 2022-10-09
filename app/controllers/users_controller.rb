class UsersController < ApplicationController

	load_and_authorize_resource

=begin	
	def index
	  if params[:approved] == "false"
	    @users = User.where(approved: false)
	  else
	    @users = User.all
	  end
	end
=end


	def index
		@users = User.all
	end


	def show
		@user = User.find(params[:id])
	end


	def new
		@user = User.new
	end

	def create  
		@user = User.new(user_params)
		@user['user_id'] = current_or_guest_user.id
		if @user.save
			redirect_to users_url
		else
			render :new, status: :unprocessable_entity
		end
	end


	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])

		if @user.update(user_params)
			redirect_to @user
		else
			render :edit, status: :unprocessable_entity
		end
	end


	def destroy
		@user = User.find(params[:id])
		@user.destroy
		#redirect_to root_path, status: :see_other
		redirect_to users_url, status: :see_other
	end


	private
		def user_params
			params.require(:user).permit(:email, :approved, :role)
		end


end