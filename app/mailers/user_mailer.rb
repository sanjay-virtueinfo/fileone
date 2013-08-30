class UserMailer < ActionMailer::Base
  #default :from => "'FileOne' <support@fileone.com>"
  default :from => "'FileOne' <nbarai77@gmail.com>"

  def registration_confirmation(email, opts)
    @username = opts[:username]
    mail(:to => "#{email}", :subject => t("general.new_registration"))
  end

  def forgot_password_confirmation(email, subject, opts)
    @username = opts[:username]
    @new_pass = opts[:new_pass]
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{email}", :subject => subject, :content_type => "text/html")
  end
  
  def share_via_email(email, opts)
    attachments.inline["Bottles.jpg"] = { :data => File.read(Rails.root.join("#{opts[:attached_file_path]}")), :mime_type => "image/png" }
    mail(:to => "#{email}", :subject => t("general.file_share_via_email"),:body => opts[:body], :content_type => "multipart/mixed")
  end
end
