require 'rails_helper'
 
RSpec.describe Group, type: :model do
    before do 
        @user= User.create(name: "User",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
        @group_work=Group.create(name: "Gr",description: "sjhd",work: true ,date_of_start: "2022-08-07",date_of_end: "2022-08-10",user_id: User.last,hours: 6, strat_hour:"08:00:00",end_hour:"17:00:00")
        @group_fun=Group.create(name: "Gr",description: "sjhd",work: false,fun: true ,date_of_start: "2022-08-07",date_of_end: "2022-08-10",user_id: User.last, hours: 6,strat_hour:"08:00:00",end_hour:"17:00:00")
    end
    context 'Attributes' do
        context 'name' do
            it 'should have a name attribute' do
              expect(@group_work).to respond_to(:name)
             end
            it 'should be invalid without a name' do @group_work.name = nil
                expect(@group_work).to be_invalid
            end
            it 'should be invalid with less caracter then 2' do @group_work.name = "a"
                expect(@group_work).to be_invalid
            end
        end
        context 'description' do
            it 'should have a description attribute' do
              expect(@group_work).to respond_to(:description)
             end
            it 'should be invalid without a description' do @group_work.description = nil
                expect(@group_work).to be_invalid
            end
        end
        context 'date_of_start' do
            it 'should have a date of start attribute' do
                expect(@group_work).to respond_to(:date_of_start)
            end
            it 'should be invalid without a date of start' do @group_work.date_of_start = nil
                expect(@group_work).to be_invalid
            end
            it 'should be smaller then date of end' do @group_work.date_of_start = "2022-08-12"
                expect(@group_work).to be_invalid
            end
        end
        context 'date_of_end' do
            it 'should have a date of end attribute' do
                expect(@group_work).to respond_to(:date_of_end)
            end
            it 'should be invalid without a date of end' do @group_work.date_of_end = nil
                expect(@group_work).to be_invalid
            end
            it 'should be greater then date of start' do @group_work.date_of_end = "2022-07-01"
                expect(@group_work).to be_invalid
            end
        end
        context 'hours' do
            it 'should have a hours attribute' do
              expect(@group_work).to respond_to(:hours)
             end
            it 'should be invalid without a hours attribute' do @group_work.hours = nil
                expect(@group_work).to be_invalid
            end
            it 'should be invalid if the hours is bigger than possible' do @group_work.hours = 100
                expect(@group_work).to be_invalid
            end
        end
        context 'user_id' do
            it 'should have a user to be generate' do
              expect(@group_work).to respond_to(:user_id)
             end
            it 'should be invalid without a user' do @group_work.user_id = nil
                expect(@group_work).to be_invalid
            end
        end

        context 'start_hour' do
            it 'should have an hour of start attribute' do
                expect(@group_work).to respond_to(:strat_hour)
            end
            it 'should be invalid without a date of start' do @group_work.strat_hour = nil
                expect(@group_work).to be_invalid
            end
            it 'should be smaller then date of end' do @group_work.strat_hour = "18:00:00"
                expect(@group_work).to be_invalid
            end
        end
    
    end
end

