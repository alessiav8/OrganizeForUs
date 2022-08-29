require 'rails_helper'


RSpec.describe "Groups", type: :request do
  before do
    @user1 = create(:user)
    @user2 = create(:user, email: "ciaociao@gm.com",username:"us2")
    @group = @user1.groups.create(attributes_for(:group))
    @group2 = @user1.groups.create(attributes_for(:group, fun:true, work:false))
  end
  describe "index" do
    it "not works! there isn't a user logged" do
      get groups_path
      expect(response).to have_http_status(302)
    end
    it "it works! if the user is logged" do
      sign_in @user1
      get groups_path
      expect(response).to have_http_status(200)
    end

  end
  describe "show" do
    it "not works! if the user isn't logged" do
      get "/groups/1/"
      expect(response).to have_http_status(302)
    end
    it "it works! there is a user logged that is the administrator or a member of the group" do
      sign_out @user1
      sign_in @user2
      get "/groups/1/"
      expect(response).to have_http_status(302)
    end
    it "it shoud render template work for work group" do
      sign_in @user1
      get "/groups/1/"
      expect(response).to render_template("work_group_show")
    end
    it "it shoud render template fun for fun group" do
      sign_in @user1
      get "/groups/2/"
      expect(response).to render_template("fun_group_show")
    end
  end

  describe "create" do
    it "it shoud be redirect to partecipation adding's page if group succesfully created" do
      sign_in @user1
      post groups_path, :params => {:group => attributes_for(:group) }
      follow_redirect!
      #expect(response.body).to_not render_template(:new)
      expect(response.body).to include("Start adding members")
    end
    it "it shoud not be redirect to partecipation adding's page if group succesfully created" do
      sign_in @user1
      post groups_path, :params => {:group => attributes_for(:group, name: "") }
      #expect(response.body).to_not render_template(:new)
      expect(response).to have_http_status(422)
    end
    it "if it work then the number of group should be increased" do
      sign_in @user1
      num= Group.all.count
      post groups_path, :params => {:group => attributes_for(:group) }
      #expect(response.body).to_not render_template(:new)
      expect(Group.all.count).to eq(num+1)
    end
  end

  describe "edit" do

    it "it shoud be not authorized if the user isn't the administrator" do
      sign_in @user2
      get "/groups/1/edit"
      expect(response).to have_http_status(302)
    end
    it "it shoud be authorized if the user is the administrator" do
      sign_in @user1
      get "/groups/1/edit"
      expect(response).to have_http_status(200)
    end
    it "it shoud be edit with valid attributes" do
          sign_in @user1
          put "/groups/1", :params => {:group => attributes_for(:group, name: "Updated") }
          follow_redirect!
          expect(response).to have_http_status(200)
    end

  end

  describe "destroy" do

    it "it shoud be not authorized if the user isn't the administrator to destroy" do
      sign_in @user2
      delete "/groups/1"
      expect(response).to have_http_status(302)
    end
    it "it shoud be authorized if the user is the administrator to destroy" do
      sign_in @user1
      delete "/groups/1"
      follow_redirect!
      expect(response).to have_http_status(200)
    end
    it "if it work then the number of group should be decreased" do
      sign_in @user1
      num= Group.all.count
      delete "/groups/1"
      #expect(response.body).to_not render_template(:new)
      expect(Group.all.count).to eq(num-1)
    end
      
end

end