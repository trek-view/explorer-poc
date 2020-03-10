if ENV['MAILERLITE_API_KEY'].present?# && (Rails.env.production? || Rails.env.staging?)
  MailerLite.configure do |config|
    config.api_key = ENV['MAILERLITE_API_KEY']
  end

  client = MailerLite::Client.new(api_key: ENV['MAILERLITE_API_KEY'])
  puts "====== client: #{client.inspect}"
  puts "====== MailerLite.client: #{MailerLite.client.inspect}"
  group = client.group(ENV['MAILERLITE_GROUP_ID'])
  puts "====== group: #{group.inspect}"
  campaign = client.create_campaign(
    type: 'regular',
    subject: 'Newsletter',
    from: ENV['MAILGUN_SMTP_LOGIN'] || 'staging-explorer@mg.trekview.org',
    from_name: ENV['MAILGUN_SMTP_LOGIN'] || 'Administrator',
    groups: [group.id],
    language: 'en'
  )
end