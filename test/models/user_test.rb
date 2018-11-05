require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test on first name (not empty not blank)
  test "First Name can't be empty" do
    user = User.new(first_name: '', last_name: 'foo', email: 'foo@foo.foo', password: 'foo')
    assert_not user.save, "first_name can't be empty"
    print "\nTest successful: 'First Name cannot be empty'"
  end

  test "First Name can't be blank" do
    user = User.new(first_name: '      ', last_name: 'foo', email: 'foo@foo.foo', password: 'foo')
    assert_not user.save, "first_name can't be blank"
    print "\nTest successful: 'First Name cannot be blank'"
  end

  test "Last Name can't be empty" do
    user = User.new(last_name: '', first_name: 'foo', email: 'foo@foo.foo', password: 'foo')
    assert_not user.save, "Last_name can't be empty"
    print "\nTest successful: 'Last Name cannot be empty'"
  end

  test "Last Name can't be blank" do
    user = User.new(last_name: '      ', first_name: 'foo', email: 'foo@foo.foo', password: 'foo')
    assert_not user.save, "Last_name can't be blank"
    print "\nTest successful: 'Last Name cannot be blank'"
  end

  test "Email can't be empty" do
    user = User.new(last_name: 'foo', first_name: 'foo', email: '', password: 'foo')
    assert_not user.save, "Last_name can't be empty"
    print "\nTest successful: 'Email cannot be empty'"
  end

  test "Email can't be blank" do
    user = User.new(last_name: 'foo', first_name: 'foo', email: '   ', password: 'foo')
    assert_not user.save, "Last_name can't be blank"
    print "\nTest successful: 'Email cannot be blank'"
  end

  test "Email must be uniq" do
    user1 = User.create(last_name: 'foo1', first_name: 'foo1', email: 'foo@foo.foo', password: 'foo1')
    user2 = User.new(last_name: 'foo2', first_name: 'foo2', email: 'foo@foo.foo', password: 'foo2')
    assert_not user2.save, "2 users can't have the same email"
    print "\nTest successful: 'Email must be uniq'"
  end
end
