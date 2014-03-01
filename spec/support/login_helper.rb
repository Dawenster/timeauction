include Warden::Test::Helpers

module LoginHelper
  def login(user)
    login_as user, scope: :user
    user
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :feature
end