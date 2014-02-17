# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Load heroku vars from local file
email_password_file = File.join(Rails.root, 'config', 'email_password.rb')
load(email_password_file) if File.exists?(email_password_file)

# Initialize the Rails application.
Timeauction::Application.initialize!
