require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do 
    @user=create(:user, email:"esempio@gmail.com",username: "esempio")
  end

  describe "authentication" do
    
    it "should sign up a valid user and be redirect on homepage" do
      post "/users", :params =>{:user => attributes_for(:user, password_confirmation:"ciaociao", password:"ciaociao")}
      follow_redirect!
      expect(response.body).to include("Welcome! You have signed up successfully.")
      expect(response).to render_template("index") #home page
    end
    it "should not sign up auser that have not valide attributes" do
      post user_registration_path, :params =>{:user => attributes_for(:user, birthday:"2000-09")}
      expect(response.body).to include("prohibited this user from being saved")
      expect(response).to render_template("new")#resta nella pagina di sign up
    end
    it "if sign up then the number of user should be increased" do
      num=User.all.count
      post "/users", :params =>{:user => attributes_for(:user, password_confirmation:"ciaociao", password:"ciaociao")}
      expect(User.all.count).to eq(num+1)
    end
    it "should log in a valid user and be redirect on homepage" do
      post "/users", :params =>{:user => attributes_for(:user, password_confirmation:"ciaociao", password:"ciaociao")}
      sign_out @user
      post "/users/sign_in", :params =>{:user => {email: attributes_for(:user)[:email], password: "ciaociao" }}
      expect(response.body).to include("Welcome! You have signed up successfully.")
      expect(response).to render_template("new") #new group page
    end
    it "should not log in up auser that have not valide attributes " do
      post "/users/sign_in", :params =>{:user => {email: attributes_for(:user)[:email], password: "ciaociao" }}
      expect(response).to render_template("new") #resta nella pagina di log in
    end
    
  end

  describe "access" do
    it "without log in a user could not access to profile!" do
      get profile_path
      expect(response).to have_http_status(302)
    end

    it "when a user log in the profile il accessible" do
      @user= create(:user)
      sign_in(@user)
      get profile_path
      expect(response).to have_http_status(200)
    end

    it "should be redirect to google accounts page" do
      get '/users/auth/google_oauth2/'
      expect(response.body).to include("accounts.google.com")
    end

    it "should be redirect to facebook accounts page" do
      get '/users/auth/facebook/'
      expect(response.body).to include("facebook.com")
    end

    it "should be redirect to github accounts page" do
      get '/users/auth/github/'
      expect(response.body).to include("github.com")
    end

    it "should be redirect to lin accounts page" do
      get '/users/auth/linkedin/'
      expect(response.body).to include("linkedin.com")
    end 
    
  end

  describe "logout" do
    it "should work if the user is log in " do 
      @user=create(:user)
      sign_in @user
      delete destroy_user_session_path
      follow_redirect!
      expect(response.body).to include("Signed out successfully.")
    end
  end

  describe "delete account" do
    it "should work if the user is log in and the confirmation password is valid " do 
      @user=create(:user) 
      sign_in @user
      delete user_registration_path, :params =>{:user => {email: attributes_for(:user), password_for_delete: "password" }}
      follow_redirect!

      expect(response.body).to include("Your account has been deleted")
    end

    it "should not work if the user is log in and the confirmation password isn't valid " do 
      @user=create(:user) 
      sign_in @user
      delete user_registration_path, :params =>{:user => {email: attributes_for(:user), password_for_delete: "passw" }}
      expect(response.body).to include("error prohibited this user")
    end
  end


end
