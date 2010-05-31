require 'spec_helper'

describe User do
  before(:each) do
    @valid_attrs = {
      :name => "John Doe",
      :email => "john@doe.com"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attrs)
  end

  it "should require a name" do
    no_name_user = User.new(@valid_attrs.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should reject too long names" do
    long_name_user = User.new(@valid_attrs.merge(:name => 'a' * 51))
    long_name_user.should_not be_valid
  end

  it "should require an e-mail addres" do
    no_email_user = User.new(@valid_attrs.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@valid_attrs.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@valid_attrs.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create!(@valid_attrs)
    user_with_duplicate_email = User.new(@valid_attrs)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @valid_attrs[:email].upcase
    User.create!(@valid_attrs.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@valid_attrs)
    user_with_duplicate_email.should_not be_valid
  end


end

