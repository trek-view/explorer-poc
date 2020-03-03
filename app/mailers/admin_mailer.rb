class AdminMailer < ActionMailer::Base
  default from: ENV['MAILGUN_SMTP_LOGIN']
  layout 'mailer'

  def notify_api_key_disabled_to_user
    @user = params[:user]
    @admin = AdminUser.first
    mail(to: @user.email, subject: 'Disabled your API key.')
  end

  def notify_api_key_enabled_to_user
    @user = params[:user]
    @admin = AdminUser.first
    mail(to: @user.email, subject: 'Enabled your API key.')
  end
end
