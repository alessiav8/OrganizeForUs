require 'rails_helper'
 


RSpec.describe Position, type: :model do
    before do 
        @user= User.create(name: "User",surname: "test", username: "user", birthday: "2001-07-07", email: "example@gm.com",password: "ciaociao")
        @group=Group.create(name: "Gr",description: "sjhd",work: true ,date_of_start: "2022-08-07",date_of_end: "2022-08-10",user_id: User.last,hours: 6, strat_hour:"08:00:00",end_hour:"17:00:00")
        @user_not_admin= User.create(name: "User",surname: "test", username: "user2", birthday: "2001-07-07", email: "example2@gm.com",password: "ciaociao")
        @event=@group.events.build(id: 1, title:'title',description:'description', mode: 'Presence',start_date: '2022-08-08', end_date: '2022-08-10',type_of_hours:"To take from to Group's hours" )
        @event.save
        @position=Position.new(street: "Via lunga 9", city:"Roma", province:"Roma", country: "Italia",event_id: 1)
        @position.save

    end
    describe 'Attributes' do 
        it 'should have a street' do
            expect(@position).to respond_to(:street)
        end
       
        it 'should be invalid without a street' do @position.street = nil
            expect(@position).to be_invalid
        end

        it 'should have a city' do
            expect(@position).to respond_to(:city)
        end

        it 'should be invalid without a city' do @position.city = nil
            expect(@position).to be_invalid
        end

        it 'should have a province' do
            expect(@position).to respond_to(:province)
        end

        it 'should be invalid without a province' do @position.province = nil
            expect(@position).to be_invalid
        end

        it 'should have a country' do
            expect(@position).to respond_to(:country)
        end

        it 'should be invalid without a country' do @position.country = nil
            expect(@position).to be_invalid
        end

        it 'should have a event id' do
            expect(@position).to respond_to(:event_id)
        end

        it 'should be invalid without a event id' do @position.event_id = nil
            expect(@position).to be_invalid
        end

        
    end



end