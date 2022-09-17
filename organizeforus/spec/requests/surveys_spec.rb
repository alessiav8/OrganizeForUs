require 'rails_helper'

RSpec.describe "Surveys", type: :request do
  before do 
    @user= create(:user)
    @group = @user.groups.build(attributes_for(:group))
    @group.save!
    @not_user= create(:user, id: 5, email: "email2@gmail.com", username: "us2")
    @member_user= create(:user, email: "email3@gmail.com", username: "us3")
    @part=Partecipation.create(group_id: @group.id, user_id: @member_user.id, accepted: true, admin: false)
    @survey= Survey.create(attributes_for(:survey, user_id: @user.id, group_id: @group.id ))
    @q1=@survey.questions.build(attributes_for(:question))
    @q1.save
    @q2=@survey.questions.build(attributes_for(:question, title: "No"))
    @q2.save

  end


  describe "authorization" do
    it "should not work to rende index if the user isn't logged" do
      get "/groups/#{@group.id}/surveys/index"
      expect(response).to have_http_status(302)
    end
    it "should work to rende index if the user is logged and is a member" do
      sign_in @user
      get "/groups/#{@group.id}/surveys/index"
      expect(response).to have_http_status(200)
    end
    it "should not work to rende index if the user is logged but isn't a member" do
      sign_in @not_user
      get "/groups/#{@group.id}/surveys/index"
      follow_redirect!
      expect(response.body).to include("Not Authorized")
      expect(response.body).to render_template("index") #home page

    end
  end

  describe "create" do
    it "should work if the user is the administartor and the attributes are valid and should redirect into surveys index " do
      sign_in @user
      post "/groups/#{@group.id}/surveys/create", :params => {:survey => attributes_for(:survey,id:1, group_id: @group.id, user_id:@user.id, :question=>{title: "No",group_id: @group.id,survey_id: 1} )}
      follow_redirect!
      expect(response.body).to render_template("index")
      expect(response.body).to include("Survey created")
    end
    it "should not work if the attributes aren't valid and should redirect into surveys index" do
      sign_in @user
      post "/groups/#{@group.id}/surveys/create", :params => {:survey => attributes_for(:survey,id:1, group_id: @group.id, user_id:@user.id,title: "", :question=>{title: "No",group_id: @group.id,survey_id: 1} )}
      follow_redirect!
      expect(response.body).to render_template("index")
      expect(response.body).to include("Survey not created, wrong attributes passed")
    end
    it "should not work if the user isn't the administrator" do
      sign_in @member_user
      post "/groups/#{@group.id}/surveys/create", :params => {:survey => attributes_for(:survey, id:1 , group_id: @group.id, user_id:@user.id, :question=>{title: "No",group_id: @group.id,survey_id: 1} )}
      follow_redirect!
      expect(response.body).to render_template("work_group_show")
      expect(response.body).to include("Not Authorized to Create Survey")
    end
    it "works and increase the number of survey" do
      sign_in @user
      num=Survey.all.count
      post "/groups/#{@group.id}/surveys/create", :params => {:survey => attributes_for(:survey,id:1, group_id: @group.id, user_id:@user.id, :question=>{title: "No",group_id: @group.id,survey_id: 1} )}
      expect(Survey.all.count).to eq(num+1)
    end
  end

  
  describe "destroy" do
    it "should work if the user is the administrator and redirect to show work" do
      sign_in @user
      get "/groups/#{@group.id}/surveys/#{@survey.id}/destroy"
      follow_redirect!
      expect(response.body).to render_template("work_group_show")
      expect(response.body).to include("Survey destroyed!")
    end
    
    it "should not work if the user the administrator, redirect to show work" do
      sign_in @member_user
      get "/groups/#{@group.id}/surveys/#{@survey.id}/destroy"
      follow_redirect!
      expect(response.body).to render_template("work_group_show")
      expect(response.body).to include("Not Authorized to Create Survey")
    end

    it "works and decrease the number of survey" do
      sign_in @user
      num=Survey.all.count
      get "/groups/#{@group.id}/surveys/#{@survey.id}/destroy"
      expect(Survey.all.count).to eq(num-1)
    end

  end


end
