# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Load heroku vars from local file
email_password_file = File.join(Rails.root, 'config', 'email_password.rb')
load(email_password_file) if File.exists?(email_password_file)

# Initialize the Rails application.
Timeauction::Application.initialize!

# Send Grid
# ActionMailer::Base.smtp_settings = {
#   :user_name => ENV['SEND_GRID_USERNAME'],
#   :password => ENV['SEND_GRID_PASSWORD'],
#   :domain => 'timeauction.org',
#   :address => 'smtp.sendgrid.net',
#   :port => 587,
#   :authentication => :plain,
#   :enable_starttls_auto => true
# }