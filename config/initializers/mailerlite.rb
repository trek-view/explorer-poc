MailerLite.configure do |config|
  config.api_key = ENV['MAILERLITE_API_KEY']
end

# MailerLite.campaigns

# MailerLite.group_subscribers(ENV['MAILERLITE_GROUP_ID'])
client = MailerLite::Client.new(api_key: ENV['MAILERLITE_API_KEY'])
group = client.group(ENV['MAILERLITE_GROUP_ID'])
campaign = client.create_campaign(
  type: 'regular',
  subject: 'Newsletter',
  from: ENV['MAILGUN_SMTP_LOGIN'],
  from_name: ENV['MAILGUN_SMTP_LOGIN'],
  groups: [group.id],
  language: 'en'
)
