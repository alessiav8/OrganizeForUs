require 'rails_helper'

RSpec.describe Event, type: :model do
    before do 
        @user= User.create(name: "User",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
        @group=Group.create(name: "Gr",description: "sjhd",work: true ,date_of_start: "2022-08-07",date_of_end: "2022-08-10",user_id: User.last,hours: 6)
        @user_not_admin= User.create(name: "User",surname: "test", username: "user2", birthday: "2001-07-07", email: "example2@gm.com",password: "ciaociao")
        @event=@group.events.build(title:'title',description:'description', mode: 'Presence',start_date: '2022-08-08', end_date: '2022-08-10', type_of_hours: "To take from to Group's hours")
        @event.save
    end
    describe 'Attributes' do 
        it 'should have a title' do
            expect(@event).to respond_to(:title)
        end
       
        it 'should be invalid without a title' do @event.title = nil
            expect(@event).to be_invalid
        end

        it 'should have a description' do
            expect(@event).to respond_to(:description)
        end

        it 'should be invalid without a description' do @event.description = nil
            expect(@event).to be_invalid
        end

        it 'should have a mode' do
            expect(@event).to respond_to(:mode)
        end

        it 'should be invalid without a mode' do @event.mode = nil
            expect(@event).to be_invalid
        end

        it 'should have a date of start' do
            expect(@event).to respond_to(:start_date)
        end

        it 'should be invalid without a date of start' do @event.start_date = nil
            expect(@event).to be_invalid
        end

        it 'should have a date of end' do
            expect(@event).to respond_to(:end_date)
        end

        it 'should be invalid without a date of end' do @event.end_date = nil
            expect(@event).to be_invalid
        end

        it 'should have a date of end greater then the date of start' do 
            @event.end_date = '2022-08-07'
            expect(@event).to be_invalid
        end

        it 'should have a user id' do
            expect(@event).to respond_to(:user_id)
        end

        it 'should be invalid without a user id' do @event.user_id = nil
            expect(@event).to be_invalid
        end

        it 'should have a group id' do
            expect(@event).to respond_to(:group_id)
        end

        it 'should be invalid without a group id' do @event.group_id = nil
            expect(@event).to be_invalid
        end

        it 'should have a type of hours' do
            expect(@event).to respond_to(:type_of_hours)
        end

        it 'should be invalid without a type of hours' do @event.type_of_hours = nil
            expect(@event).to be_invalid
        end

    end



end