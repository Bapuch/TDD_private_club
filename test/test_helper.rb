ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module SignInHelper
  def is_logged_in?(user)
    params = {}
    params[:session] = {email: user.email, password: user.password}
    post login_url(params)
  end

  def logged?
    puts "curernt_user : #{current_user}"
    !current_user.nil?
  end
end

module ParamUserHelper
  def param_user(user)
    {user: {last_name: user.last_name, first_name: user.first_name, email: user.email, password: user.password}}
  end

  def param_user_no_pwd(user)
    {user: {last_name: user.last_name, first_name: user.first_name, email: user.email}}
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
  include ParamUserHelper
end