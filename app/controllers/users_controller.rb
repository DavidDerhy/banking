class UsersController < ApplicationController
	before_filter :authenticate, :except => [:login]

	def login
		if request.post? #In the simple case of this app, route get and post through the same controller action to keep the code clean
		    if session[:user] = User.authenticate(params[:user][:username], params[:user][:password])
		        flash[:message]  = "Welcome, my child."
		        redirect_to :transfer
		    else
		        flash[:warning] = "Thou shall not pass!"
		    end
		end
	end

	def logout
	    session[:user] = nil
	    flash[:message] = 'Thou shalt return!'
	    redirect_to :login
  	end

  	def transfer
		if request.post? #In the simple case of this app, route get and post through the same controller action to keep the code clean
			if current_user.transfer(params[:recipient][:username], params[:recipient][:amount].to_d)
				flash[:message] = (params[:recipient][:amount]).to_s + " transferred to " + params[:recipient][:username]
		  		redirect_to :transfer
			else
		  		flash[:warning] = "Thou shalt not perform an invalid transfer!"
		  		redirect_to :transfer
			end
		elsif request.get?
			@recipients = User.all(:conditions => (current_user ? ["id != ?", current_user.id] : [])) #Get all possible users to transfer money to, thus excluding myself
			@current_user = current_user
			#Get all my transfer logs (incoming and outgoing) and order them by date
			@transfer_logs = @current_user.debit_logs + @current_user.credit_logs
			@transfer_logs.sort_by!(&:created_at).reverse!
		end
	end
end
