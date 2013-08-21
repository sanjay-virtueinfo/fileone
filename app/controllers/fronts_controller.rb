class FrontsController < ApplicationController
	require 'builder'
  before_filter :require_user, :only => [:change_password]
  before_filter :set_header_menu_active
  
  #dashboard
  def dashboard
  	if current_user
      @user = User.find(current_user.id)
  	end	
  end
  
	#forgot password
  def forgot_password
		@user = User.new
		if params[:user]
			if user = authenticate_email(params[:user][:email])
				new_pass = SecureRandom.hex(5)
				user.password = user.password_confirmation = new_pass
				user.save
				body = render_to_string(:partial => "common/forgot_password_mail", :locals => { :username => user.username, :new_pass => new_pass }, :formats => [:html])
				body = body.html_safe
				UserMailer.forgot_password_confirmation(user.email, new_pass, body).deliver
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
	        format.html { redirect_to users_url, notice: t("general.successfully_updated") }
	        format.json { head :no_content }
	      else
	        format.html { render action: 'change_password' }
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
  
end
