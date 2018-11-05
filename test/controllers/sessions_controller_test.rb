require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(last_name: 'foo1', first_name: 'foo1', email: 'foo@foo.foo', password: 'foo1')
  end

  test 'correct information => log in successful' do
    @user = User.create(last_name: 'foo1', first_name: 'foo1', email: 'foo@foo.foo', password: 'foo1')
    post login_path, params: { session: {email: @user.email, password: @user.password } }
    # if ok, redirects to show page
    assert_response :redirect
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in? @user
    print "\nTest successful: 'correct information => log in successful'"
  end

  test 'wrong password => log in failed' do
    @user = User.create(last_name: 'foo1', first_name: 'foo1', email: 'foo@foo.foo', password: '')
    post login_path, params: { session: {email: @user.email, password: 'prout' } }
    # if NOK, alert message
    assert_equal flash[:alert], "Sorry log in failed!"
    print "\nTest successful: 'wrong password => log in failed'"
  end
end
