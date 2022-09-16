require 'rails_helper'
 


RSpec.describe Survey, type: :model do
    before do 
        @user= User.create(name: "User",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
        @group=Group.create(name: "Gr",description: "sjhd",work: true ,date_of_start: "2022-08-07",date_of_end: "2022-08-10",user_id: User.last,hours: 6, strat_hour:"08:00:00",end_hour:"17:00:00")
        #@user_not_admin= User.create(name: "User",surname: "test", username: "user2", birthday: "2001-07-07", email: "example2@gm.com",password: "ciaociao")
        @survey=@group.surveys.build(title:'title',body:'description')
        @survey.save
    end
    describe 'Attributes' do 
        it 'should have a title' do
            expect(@survey).to respond_to(:title)
        end
       
        it 'should be invalid without a title' do @survey.title = nil
            expect(@survey).to be_invalid
        end

        it 'should have a description' do
            expect(@survey).to respond_to(:body)
        end

        it 'should be invalid without a description' do @survey.body = nil
            expect(@survey).to be_invalid
        end

        it 'should be invalid with a title contain less then 2 characters' do @survey.title = "a"
            expect(@survey).to be_invalid
        end

        it 'should be invalid with a description contain less then 2 characters' do @survey.body = "a"
            expect(@survey).to be_invalid
        end
        
    end



end