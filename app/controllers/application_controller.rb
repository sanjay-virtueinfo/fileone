class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :is_admin?, :is_user?
	SUPER_ADMIN = "SuperAdmin"
	USER = "User"

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
		@current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      redirect_to :controller => "user_sessions", :action => "new"
    end
  end
  
  def require_admin
    unless current_user
      redirect_to :controller => "user_sessions", :action => "new"
    else
      unless is_admin?
        redirect_to :controller => "fronts", :action => "dashboard"
      end  
    end  
  end  
 
  def authenticate_email(email)
    user_exists = User.exists?(email: email)
    if user_exists
			user = User.find_by_email(email)
			return user
	  end
	  return false
  end
  
  def authenticate_change_password(password)
      user_exists = User.exists?(password: password)
      if user_exists
		user = User.find_by_password(password)
		return user
	  end
	  return false
  end

	def is_admin?
		session[:user_role] == SUPER_ADMIN
	end
	
  def is_user?
	 session[:user_role] == USER
  end
  
  #save file on cloud
  def save_file_on_cloud(folder)
    
    directory_file = Rails.public_path.to_s + folder.file_path.to_s
    
    secure_file_name = "QloudShare/" + folder.name.to_s
    
    s3 = AWS::S3.new.buckets[AMAZON_S3_BUCKET].objects[secure_file_name]
    
    s3.write(:file => directory_file, :acl => :public_read)
    
    File.delete(directory_file)
    
    folder.amazon_file_path = secure_file_name
    
    folder.save
  end  
  
end