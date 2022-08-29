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
      follow_redirect!
      expect(response.body).to include("Signed in successfully.")
      expect(response).to render_template("index") #home page
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
  end

end
