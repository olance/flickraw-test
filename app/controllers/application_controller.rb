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
    redirect_to auth_path and return if not @user.token
    
    begin
      @auth = flickr.auth.checkToken
      flash[:success] = "You are authenticated with Flickr as '#{@auth.user.username}'"
    rescue FlickRaw::FailedResponse => e
      flash[:error] = "You need to authenticate again (#{e.msg})"
      @user.token = nil
      @user.save
      redirect_to auth_path and return
    end
    
    @photos = flickr.people.getPhotos :user_id => "me", :per_page => 10, :page => params[:page] || 1
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
    FlickRaw.api_key = "YOUR_KEY"
    FlickRaw.shared_secret = "YOUR_SECRET"
  end
  
  def get_user
    @user = User.find :first
  end
  
end
