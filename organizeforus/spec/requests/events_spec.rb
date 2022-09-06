require 'rails_helper'

RSpec.describe "Events", type: :request do
  before do
    @user1 = create(:user)
    @user2 = create(:user, email: "ciaociao@gm.com",username:"us2")
    @group = @user1.groups.create(attributes_for(:group))
    @event= @group.events.create(attributes_for(:event, user_id: @user1.id))
  end

  describe "Authentication" do 
    it "should be not possible to render event index of a group if you are not a member of the group" do 
      sign_in @user2
      get "/groups/#{@group.id}/events"
      expect(response).to have_http_status(302)
    end
    it "should be not possible to render event index of a group if you are not logged in" do 
      get "/groups/#{@group.id}/events"
      expect(response).to have_http_status(302)
    end
   

  end


end
