if ENV['MAILERLITE_API_KEY'].present? && (Rails.env.production? || Rails.env.staging?)
  MailerLite.configure do |config|
    config.api_key = ENV['MAILERLITE_API_KEY']
  end

  client = MailerLite::Client.new(api_key: ENV['MAILERLITE_API_KEY'])
  group = client.group(ENV['MAILERLITE_GROUP_ID'])
  campaign = client.create_campaign(
    type: 'regular',
    subject: 'Newsletter',
    from: ENV['MAILGUN_SMTP_LOGIN'] || 'staging-explorer@mg.trekview.org',
    from_name: ENV['MAILGUN_SMTP_LOGIN'] || 'Administrator',
    groups: [group.id],
    language: 'en'
  )
end