require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :name => "Test User",
      :email => "test.user@example.com",
      :password => "testpass",
      :password_confirmation => "testpass"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should reject too long names" do
    long_name_user = User.new(@attr.merge(:name => 'a' * 51))
    long_name_user.should_not be_valid
  end

  it "should require an e-mail addres" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
      should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end 

    end

  end

  describe "authenticate user" do

    it "should return nil if there is no user with this e-mail" do
      nonexistent_user = User.authenticate("wrongemail@foo.com", @attr[:password])
      nonexistent_user.should be_nil
    end

    it "should return nil if the password is wrong" do
      wrong_pass_user = User.authenticate(@attr[:email], "wrongpass")
      wrong_pass_user.should be_nil
    end

    it "should return user if e-mail and password match" do
      correct_user = User.authenticate(@attr[:email], @attr[:password])
      correct_user.should == @user
    end

  end

  describe "remember me" do

    before(:each) do
      @user = User.create(@attr)
    end

    it "should have a remember token" do
      @user.should respond_to(:remember_me!)
    end

    it "should set the remember token" do
      @user.remember_me!
      @user.remember_token.should_not be_nil
    end
    
  end

end

