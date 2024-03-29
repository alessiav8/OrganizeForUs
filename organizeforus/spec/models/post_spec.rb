require 'rails_helper'
 


RSpec.describe Post, type: :model do
    before do 
        @user= User.create(name: "User",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
        @group_work=Group.create(name: "Gr",description: "sjhd",work: true ,date_of_start: "2022-08-07",date_of_end: "2022-08-10",user_id: User.last,hours: 6, start_hour:"08:00:00",end_hour:"17:00:00")
        @post= Post.create(title: "Titolo", body: "Descrizione" ,user_id: @user.id,group_id: @group_work.id)
    end
    context 'Attributes' do
        context 'title' do
            it 'should have a title attribute' do
              expect(@post).to respond_to(:title)
             end
            it 'should be invalid without a title' do @post.title = nil
                expect(@post).to be_invalid
            end
        end
        context 'body' do
            it 'should have a body attribute' do
              expect(@post).to respond_to(:body)
             end
            it 'should be invalid without a body' do @post.body = nil
                expect(@post).to be_invalid
            end
            it 'should be invalid without a body with at least 2 characters' do @post.body = "a"
                expect(@post).to be_invalid
            end
        end
        context 'group_id' do
            it 'should have a group to be generate' do
              expect(@post).to respond_to(:group_id)
             end
            it 'should be invalid without a group' do @post.group_id = nil
                expect(@post).to be_invalid
            end
        end
        context 'user_id' do
            it 'should have a user to be generate' do
              expect(@post).to respond_to(:user_id)
             end
            it 'should be invalid without a user' do @post.user_id = nil
                expect(@post).to be_invalid
            end
        end
        
    end
end

  
 

