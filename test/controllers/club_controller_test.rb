require 'test_helper'

class ClubControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(last_name: 'foo1', first_name: 'foo1', email: 'foo@foo.foo', password: 'foo1')
  end

  test 'the navbar display the logout and private club links if user is logged in' do
    assert is_logged_in? @user
    get root_path
    # check if logout and privateclub link are visible & login and register links are disabled
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", privateclub_path
    assert_select "a[href=?]", user_path(@user.id)
    assert_select "a[href=?]", login_path, false
    assert_select "a[href=?]", new_user_path, false
    print "\nTest successful: 'the navbar display the logout and private club links if user is logged in'"
  end

  test 'the navbar display the log in and register links if user is not logged in' do
    get root_path
    # check if logout and privateclub link are disabled & login and register links are visible
    assert_select "a[href=?]", logout_path, false
    assert_select "a[href=?]", privateclub_path, false
    assert_select "a[href=?]", user_path(@user.id), false
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", new_user_path
    print "\nTest successful: 'the navbar display the log in and register links if user is logged in'"
  end

  test 'the private club page is accessible to logged in user' do
    assert is_logged_in? @user
    get privateclub_path
    assert_response :success
    print "\nTest successful: 'the private club page is accessible to logged in user'"
  end

  test 'the private club page is NOT accessible if no one is logged' do
    get privateclub_path
    assert_response :redirect
    follow_redirect!
    assert_template root_path
    assert_equal flash[:alert], 'Nice try! Please log in to enter the club'
    print "\nTest successful: 'the private club page is NOT accessible if no one is logged'"
  end

  test 'private club page displays the list of all the users' do
    is_logged_in? @user
    get privateclub_path
    # check if for each user, the first_name, last_name, email and link to show page is available
    User.all.each do |user|
      assert_match user.first_name, response.body
      assert_match user.last_name, response.body
      assert_match user.email, response.body
      assert_match user_path(user.id), response.body
    end
    print "\nTest successful: 'private club page displays the list of all the users'"
  end

  test 'show page for logged in user is accessible from navbar' do
    assert is_logged_in? @user
    get root_path
    assert_select "a[href=?]", user_path(@user.id)
    print "\nTest successful: 'show page for logged in user is accessible from navbar'"
  end

  test 'show page for is NOT accessible is no one is logged' do
    get root_path
    assert_select "a[href=?]", user_path(@user.id), false
    print "\nTest successful: 'show page for is NOT accessible is no one is logged'"
  end
end
