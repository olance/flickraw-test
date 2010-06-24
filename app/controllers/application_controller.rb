# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require "flickraw"

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :setup_flickraw
  before_filter :get_user

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def index
    redirect_to auth_url and return if not @user.token
    
    auth = flickr.auth.checkToken
    flash[:success] = "You are authenticated with Flickr as '#{auth.user.username}'"
  end
  
  def auth
    frob = flickr.auth.getFrob
    @auth_url = FlickRaw.auth_url :frob => frob, :perms => 'read'
  end
  
  def complete_auth
    if not params[:frob]
      flash[:error] = "Flickr Authentication wasn't performed correctly"
      redirect_to root_path
      return
    end
    
    auth = flickr.auth.getToken :frob => params[:frob]
    login = flickr.test.login
    
    @user.token = auth.token
    @user.save
    
    flash[:success] = "You are authenticated with Flickr as '#{login.username}'"
    redirect_to root_path and return
    
  rescue FlickRaw::FailedResponse => e
    flash[:error] = "Authentication error: #{e.msg}"
    redirect_to root_path
    return
  end
  
protected
  def setup_flickraw
    FlickRaw.api_key = "6eb9a6f841c27d55450db8f96a5411ef"
    FlickRaw.shared_secret = "387d8e8c2d3f27b2"
  end
  
  def get_user
    @user = User.find :first
  end
  
end
