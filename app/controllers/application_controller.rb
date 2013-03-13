class ApplicationController < ActionController::Base
	protect_from_forgery

	def authenticate
	    if session[:user]
	      return true
	    end
	    flash[:warning] = 'Thou shalt authenticate!'
	    redirect_to :controller => "users", :action => "login"
	    return false 
	end

	def current_user
    	session[:user]
  	end	
end
