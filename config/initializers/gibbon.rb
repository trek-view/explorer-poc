Gibbon::Request.api_key = Explorer.credentials[:mailchimp_api_key]
Gibbon::Request.timeout = 15
Gibbon::Request.open_timeout = 15
Gibbon::Request.symbolize_keys = true
Gibbon::Request.debug = false