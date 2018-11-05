require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = User.create(last_name: 'foo1', first_name: 'foo1', email: 'foo@foo.foo', password: 'foo1')
    @user2 = User.create(last_name: 'boo', first_name: 'boo', email: 'boo@boo.boo', password: 'boo1')
  end

  test "valid signup information" do
    user = User.new(last_name: 'foo', first_name: 'foo', email: 'foo@foo.com', password: 'foo12')
    # test if user is created
    assert_difference 'User.count' do
      post users_url, params: param_user(user)
    end
    # test if the user is redirected to its personal page
    assert_response :redirect
    follow_redirect!
    assert_template 'users/show'
    # test if user is ogged in
    assert is_logged_in? user
    print "\nTest successful: 'valid signup information'"
  end

  test "Create User: first_name information is empty or blank" do
    # is empty/nil
    user = User.new(last_name: 'foo', first_name: '', email: 'foo@foo.foo', password: 'foo12')
    is_missing_test(user)
    # is blank
    user = User.new(last_name: 'foo', first_name: '     ', email: 'foo@foo.foo', password: 'foo12')
    is_missing_test(user)
    print "\nTest successful: 'Create User: first_name information is empty or blank'"
  end

  test "Create User: last_name information is empty or blank" do
    # is empty/nil
    user = User.new(last_name: '', first_name: 'foo', email: 'foo@foo.foo', password: 'foo12')
    is_missing_test(user)
    # is blank
    user = User.new(last_name: '', first_name: 'foo', email: 'foo@foo.foo', password: 'foo12')
    is_missing_test(user)
    print "\nTest successful: 'Create User: last_name information is empty or blank'"
  end

  test "Create User: email information is missing" do
    # is empty/nil
    user = User.new(last_name: 'foo', first_name: 'foo', email: '', password: 'foo12')
    is_missing_test(user)
    # is blank
    user = User.new(last_name: 'foo', first_name: 'foo', email: '', password: 'foo12')
    is_missing_test(user)
    print "\nTest successful: 'Create User: email information is empty or blank'"
  end

  test 'Create User: email is already taken' do
    user = User.create(last_name: 'foo2', first_name: 'foo2', email: 'foo@foo.foo', password: 'foo13')
    is_missing_test(user)
    print "\nTest successful: 'Create User: email information is already taken'"
  end

  # method to test missing/invalid parameters
  def is_missing_test(user)
    # test if no user is created (difference is 0)
    assert_difference 'User.count', 0 do
      post users_url, params: param_user(user)
    end
    # test that the user object is not valid
    assert_not user.valid?, 'if email is missing then should return an error'
    # test that the flash message sends an error
    assert_equal flash[:alert], "Something went wrong: #{user.errors.full_messages}"
  end

  test "Read: show page displays user's information" do
    is_logged_in? @user
    get user_path(@user.id)
    # all information must be present in the body
    assert_match @user.first_name, response.body
    assert_match @user.last_name, response.body
    assert_match @user.email, response.body
    print "\nTest successful: 'Read: show page displays user information'"
  end

  test 'Read: logged in user can access any show page' do
    is_logged_in? @user
    get user_path(@user.id)
    # logged in user can access its own personnal page
    assert_response :success

    # can also access another user's personal page
    get user_path(@user2.id)
    assert_response :success
    print "\nTest successful: 'Read: logged in user can access any show page'"
  end

  test 'show page is not accessible if user is not logged' do
    # can't access another user's personal page
    get user_path(@user.id)#user_path(@user.id)
    # redirection to the login page
    assert_response :redirect
    assert_redirected_to login_path
    # flash alert message
    assert_equal flash[:alert], "Sorry, you must login to access to this page"
    print "\nTest successful: 'Read: show page is not accessible if user is not logged'"
  end

  test 'Update: logged in user can only edit its own personnal page' do
    is_logged_in? @user
    get edit_user_path(@user.id)
    # logged in user can access its own personnal page
    assert_response :success

    # can't access another user's personal page
    get edit_user_path(@user2.id)
    # redirection to the login page
    assert_response :redirect
    follow_redirect!
    assert_template root_path
    # flash alert message
    assert_equal flash[:alert], "Sorry, you don't have access rights to this page"
    print "\nTest successful: 'Update: logged in user can only edit its own personnal page'"
  end

  test 'Update: edit page is not accessible if user is not logged' do
    # can't access another user's personal page
    get edit_user_path(@user.id)#user_path(@user.id)
    # redirection to the login page
    assert_response :redirect
    assert_redirected_to login_path
    # flash alert message
    assert_equal flash[:alert], "Sorry, you must login to access to this page"
    print "\nTest successful: 'Update: edit page is not accessible if user is not logged'"
  end

  test 'Update: logged in user can see edit and delete button for its own show page ONLY' do
    is_logged_in? @user
    get user_path(@user.id)
    # can see buttons for its own page
    assert_select "a[href=?]", edit_user_path(@user.id)
    assert_select "a[href=?]", user_path(@user.id)
    # cannot see buttons for any other user's page
    get edit_user_path(@user2.id)
    assert_select "a[href=?]", edit_user_path(@user2.id), false
    assert_select "a[href=?]", user_path(@user2.id), false
    print "\nTest successful: 'Update: logged in user can see edit and delete button for its own show page ONLY'"
  end

  test 'Update: new data are valid' do
    user = User.new(last_name: 'food1', first_name: 'food1', email: 'food@foo.foo')
    put user_path(@user.id), params: param_user_no_pwd(user)
    # redirects to the show page if OK
    assert_redirected_to user_path(@user.id)
    # check that @user has been updated with the parameters from the user variable
    @user.reload
    assert_equal @user.last_name, user.last_name
    assert_equal @user.first_name, user.first_name
    assert_equal @user.email, user.email
    print "\nTest successful: 'Update: new data are valid'"
  end

  test 'Update: new data are invalid' do
    # last name is empty
    user = User.new(last_name: '', first_name: 'food1', email: 'food@foo.foo')
    is_missing_edit(user, :last_name)
    # last name is empty
    user = User.new(last_name: '    ', first_name: 'food1', email: 'food@foo.foo')
    is_missing_edit(user, :last_name)
    # first name is empty
    user = User.new(last_name: 'food', first_name: '', email: 'food@foo.foo')
    is_missing_edit(user, :first_name)
    # first name is blank
    user = User.new(last_name: 'food', first_name: '      ', email: 'food@foo.foo')
    is_missing_edit(user, :first_name)
    # email is blank
    user = User.new(last_name: 'food', first_name: 'food1', email: '')
    is_missing_edit(user, :email)
    # email is blank
    user = User.new(last_name: 'food', first_name: 'food1', email: '    ')
    is_missing_edit(user, :email)
    # email is already taken
    user = User.new(last_name: 'food', first_name: 'food1', email: @user2.email)
    is_missing_edit(user, :email)
    print "\nTest successful: 'Update: new data are invalid'"
  end

  def is_missing_edit(user, field)
    put user_path(@user.id), params: param_user_no_pwd(user)
    # redirects to the edit page if NOK
    assert_redirected_to edit_user_path(@user.id)
    # check that @user has been updated with the parameters from the user variable
    @user.reload
    assert_not_equal @user[field], user[field]
  end
end
