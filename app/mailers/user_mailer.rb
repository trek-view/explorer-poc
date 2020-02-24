class UserMailer < ActionMailer::Base
  default from: ENV['MAILGUN_SMTP_LOGIN']
  layout 'mailer'

  def submit_require_apikey_email
    @user = params[:user]
    @admin = AdminUser.first
    @url = "https://#{ENV['SITE_URL']}/admin/users/#{@user.id}/edit"
    mail(to: @user.email, subject: 'Require API key usage.')
  end
end
