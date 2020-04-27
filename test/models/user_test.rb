
# test/models/user_test.rb
require File.expand_path("../../test_helper", __FILE__)
# require 'active_record'
# require_relative '../../app/models/application_record.rb'
# require_relative '../../app/models/user.rb'


class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    user = User.new(user_name: 'Jade123', email: 'john@example.com', profile: 'hello', phone: 1234567890,
    password: '1234567890')
    assert user.valid?
    user.destroy
  end

  test 'user invalid without username' do
    user = User.new(email: 'john@example.com', profile: 'hello', phone: 1234567890,
    password: '1234567890')
    refute user.valid?, 'user is valid without a name'
    assert_not_nil user.errors[:name], 'no validation error for name present'
    user.destroy
  end

  test 'user has invalid email' do
    user = User.new(email: 'j', profile: 'hello', phone: 1234567890,
    password: '1234567890')
    refute user.valid?, 'user is valid with invalid email'
    assert_not_nil user.errors[:email], 'no validation error for email present'
    user.destroy
  end

  test 'user has invalid password' do
    user = User.new(email: 'john@example.com', profile: 'hello', phone: 1234567890,
    password: '12')
    refute user.valid?, 'user is valid without a proper password'
    assert_not_nil user.errors[:password], 'no validation error for short password present'
    user.destroy
  end
end