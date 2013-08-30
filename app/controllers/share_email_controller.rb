class ShareEmailController < ApplicationController
  def index
    @o_share = Share.new
  end

  def create
    @o_share = Share.new(share_params)
    if request.post?
      if @o_share.save        
        body = render_to_string(:partial => "common/share_via_email", :formats => [:html])
			  body = body.html_safe
        opts = {:attached_file_path => "public/uploads/folder/file_path/8/Bottles.jpg", :body => body}
			  UserMailer.share_via_email(@o_share.shared_by, opts).deliver
        redirect_to users_url, notice: t("general.successfully_shared")
      else
        render action: 'index'
      end
    end
  end

  private
    def share_params
      params.require(:share).permit!
    end
end
