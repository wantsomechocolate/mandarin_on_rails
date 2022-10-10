class TasksController < ApplicationController

	skip_authorization_check

	def delete_stale_guest_users
		stale_users = User.where(guest: true).where(created_at: ..(Time.now.midnight - 7.day) )
		puts stale_users
		
		if stale_users.destroy_all
			render :json => {"staus" => "success"}
		else
			render :json => {"staus" => "failure"}
		end

	end

end
