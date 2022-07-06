class ApplicationController < ActionController::Base
    # skip_before_action :verify_authenticity_token # bypass token authenticity

    helper_method :current_user, :logged_in?

    def current_user
        return nil unless session[:session_token]
        @current_user ||= User.find_by(session_token: session[:session_token])
    end 

    def require_logged_in
        redirect_to new_session_url unless logged_in?
    end 

    def require_logged_out
        redirect_to users_url if logged_in?
    end

    def logged_in?
        !current_user.nil?
    end 


    def login(user)
        session[:session_token] = user.reset_session_token! # we should reset user token everytime 
    end 

    def logout!
        current_user.reset_session_token!
        session[:session_token] = nil 
    end
end
