require 'rails_helper'
 


RSpec.describe Comment, type: :model do
    before do 
        @user= User.create(name: "User",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
        @group=Group.create(name: "Gr",description: "sjhd",work: true ,date_of_start: "2022-08-07",date_of_end: "2022-08-10",user_id: User.last,hours: 6, strat_hour:"08:00:00",end_hour:"17:00:00")
        @post= Post.create(id: 2, title: "Titolo", body: "Descrizione" ,user_id: @user.id,group_id: @group.id)
        @comment=Comment.create(text: "Questo testo sarebbe il testo del commento", user_id: @user.id, post_id: 2, id: 1)

    end
    describe 'Attributes' do 
        it 'should have a text' do
            expect(@comment).to respond_to(:text)
        end
       
        it 'should be invalid without a text' do @comment.text = nil
            expect(@comment).to be_invalid
        end

        it 'should be invalid with a text contain less then 3 characters' do @comment.text = "a"
            expect(@comment).to be_invalid
        end

        it 'should have a post id' do
            expect(@comment).to respond_to(:post_id)
        end
       
        it 'should be invalid without a post id' do @comment.post_id = nil
            expect(@comment).to be_invalid
        end
        it 'should have a user id' do
            expect(@comment).to respond_to(:user_id)
        end
       
        it 'should be invalid without a user id' do @comment.user_id = nil
            expect(@comment).to be_invalid
        end

        
    end



end