class FrontsController < ApplicationController
	require 'builder'
  before_filter :require_user, :only => [:change_password]
  before_filter :set_header_menu_active
  skip_before_filter :verify_authenticity_token, :only => [:dashboard]
  
  #dashboard
  def dashboard
    redirect_to folders_url if current_user
    
    @o_single = Folder.new
    @user_session = UserSession.new
    @o_user = User.new
    @folder = session[:folder_temp_id] ? (Folder.find(session[:folder_temp_id])) : nil
    
  	if request.post?
  	  @o_single = Folder.new(folder_params)
      if params[:folder] and params[:folder][:file_path] and @o_single.save
        if @o_single.file_path
          folder_attr = {file_size: @o_single.file_path.size.to_f,
                         file_content_type: params[:folder][:file_path].content_type,
                         name: @o_single.file_path.filename,
                         is_folder: false}
          @o_single.update_attributes(folder_attr)
          session[:folder_temp_id] = @o_single.id
        else
          flash[:error] = t("general.file_not_saved")
        end
      end
    end
  end  
  
  def show_search_box
    @o_single = params[:model].constantize.new
    @params_arr = params[:pm].split(',')
  end  
  
  #forgot password
  def forgot_password
    @user = User.new
    if params[:user]
      if user = authenticate_email(params[:user][:email])
        new_pass = SecureRandom.hex(5)
        user.password = user.password_confirmation = new_pass
        user.save
        
        #options
        opts = { :username => user.name, :new_pass => new_pass }    
        
        #subject
        subject = t("general.reset_password")
        
        #send mail
        UserMailer.forgot_password_confirmation(user.email, subject, opts).deliver        
        
        @user_session = UserSession.find
        if @user_session
          @user_session.destroy
        end
        session[:user_id] = nil
        flash[:notice] = t("general.password_has_been_sent_to_your_email_address")
        redirect_to root_path 
      else
        flash[:forgot_pass_error] = t("general.no_user_exists_for_provided_email_address")
        redirect_to :action => "forgot_password"
      end
    end 
  end

  #change password
  def change_password
    @o_single = User.find(current_user.id)
    if params[:user]
      @o_single.password = params[:user][:password]
      @o_single.password_confirmation = params[:user][:password_confirmation]
      @o_single.password_required = true
      respond_to do |format|
        if @o_single.update_attributes(user_params)
          format.html { redirect_to users_url, notice: t("general.password_successfully_updated") }
          format.json { head :no_content }
        else
          format.html { render action: 'change_password' }
          format.json { render json: @o_single.errors, status: :unprocessable_entity }
        end
      end
    end  
  end
  
  #profile
  def profile
    @o_single = User.find(current_user.id)
    if params[:user]    
      respond_to do |format|
        if @o_single.update_attributes(user_params)
          format.html { redirect_to profile_url, notice: t("general.successfully_updated") }
          format.json { head :no_content }
        else
          format.html { render action: 'profile' }
          format.json { render json: @o_single.errors, status: :unprocessable_entity }
        end
      end      
    end
  end  
  
	#footer and other static pages
  def other
  	@o_single = StaticPage.where(page_route: params[:page_id]).first
  end
  

	private
 	
  def set_header_menu_active
    @dashboard = true
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit!
  end
  
  def folder_params
    params.require(:folder).permit!
  end  
  
end
