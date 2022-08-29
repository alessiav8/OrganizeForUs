require 'rails_helper'
 


RSpec.describe User, type: :model do
    before do 
        @user= User.create(name: "User",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
    end
    context 'Attributes' do
        context 'name' do
            it 'should have a name attribute' do
              expect(@user).to respond_to(:name)
             end
            it 'should be invalid without a name' do @user.name = nil
                expect(@user).to be_invalid
            end
        end
        context 'surname' do
            it 'should have a surname attribute' do
              expect(@user).to respond_to(:surname)
             end
            it 'should be invalid without a description' do @user.surname = nil
                expect(@user).to be_invalid
            end
        end
        context 'username' do
            it 'should have a username attribute' do
              expect(@user).to respond_to(:username)
             end
            it 'should be invalid without a description' do @user.username = nil
                expect(@user).to be_invalid
            end
        end
        context 'birthday' do
            it 'should have a birthday attribute' do
              expect(@user).to respond_to(:birthday)
             end
            it 'should be invalid without a birthday' do @user.birthday = nil
                expect(@user).to be_invalid
            end
        end
        context 'email' do
            it 'should have a email attribute' do
              expect(@user).to respond_to(:email)
             end
            it 'should be invalid without a email' do @user.email = nil
                expect(@user).to be_invalid
            end
        end
    end
end


RSpec.describe User, "#create" do
    it "should create new user if i pass valid attributes" do 
        @user= User.create(name: "User",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
        expect(@user).to be_valid
    end
    it "should not create new user if i pass not valid attributes" do 
        @user= User.create(name: "",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
        expect(@user).to be_invalid
    end
end

RSpec.describe User, "#update" do
    before do 
        @user= User.create(name: "User",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
    end
    it "should update user if i pass valid attributes" do 
        @user.update(name: "User Updated",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
        expect(@user).to be_valid
    end
    it "should not be update user if i pass not valid attributes" do 
        @user.update(name: "",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
        expect(@user).to be_invalid
    end
end