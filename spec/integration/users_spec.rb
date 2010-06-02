require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          click_button
          response.should render_template('users/new')
          response.should have_tag('div#errorExplanation')
        end.should_not change(User, :count)
      end

    end

    describe "success" do

      it "should make a new user" do

        lambda do
          visit signup_path
          fill_in :user_name,     :with => "Example User"
          fill_in :user_email,    :with => "user@example.com"
          fill_in :user_password, :with => "foobar"
          fill_in :user_password_confirmation, :with => "foobar"
          click_button
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
        
      end
      
    end

  end

  describe "Sign in/out" do

    describe "failure" do
      
      it "should not sign a user in" do
        @user = User.create
        integration_sign_in(@user)
        response.should render_template('sessions/new')
        response.should have_tag("div.flash.error", /invalid/i)
      end

    end

    describe "success" do

      it "should sign a user in and out" do
        @user = Factory(:user)
        integration_sign_in(@user)
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end

    end

  end

end
