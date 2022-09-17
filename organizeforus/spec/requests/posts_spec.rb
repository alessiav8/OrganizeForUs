require 'rails_helper'

RSpec.describe "Posts", type: :request do
  before do 
    @user= create(:user)
    @group = @user.groups.build(attributes_for(:group))
    @group.save!
    @not_user= create(:user, id: 5, email: "email2@gmail.com", username: "us2")
    @member_user= create(:user, email: "email3@gmail.com", username: "us3")
    @part=Partecipation.create(group_id: @group.id, user_id: @member_user.id, accepted: true, admin: false)
    @post= @user.posts.build(attributes_for(:post, group_id: @group.id))
    @post.save!
  end


  describe "authorization" do
    it "should be not authorized to enter into the post's index if the user is not logged" do
      get "/groups/#{@group.id}/posts"
      expect(response).to have_http_status(302)
    end
    it "should be authorized to enter into the post's index if the user is logged and a member" do
      sign_in @user
      get "/groups/#{@group.id}/posts"
      expect(response).to have_http_status(200)
    end
    it "should be not authorized to enter into the post's index if the user is logged but is not a member" do
      sign_in @not_user
      get "/groups/#{@group.id}/posts"
      expect(response).to have_http_status(302)
    end
  end

  describe "create" do
    it "should be created if the user is valid and the attributes are valid and should redirect into post show view" do
      sign_in @user
      post "/groups/#{@group.id}/posts", :params => {:post => attributes_for(:post, group_id: @group.id, user_id:@user.id) }
      follow_redirect!
      expect(response.body).to render_template("show")
      expect(response.body).to include("Post created")
    end
    it "should not be created if the attributes aren't valid and should redirect into posts index" do
      sign_in @user
      post "/groups/#{@group.id}/posts", :params => {:post => attributes_for(:post, title: "", group_id: @group.id, user_id:@user.id) }
      follow_redirect!
      expect(response.body).to render_template("index")
      expect(response.body).to include("Not possibile to create post")
    end
    it "works and increase the number of posts" do
      sign_in @user
      num=Post.all.count
      post "/groups/#{@group.id}/posts", :params => {:post => attributes_for(:post, group_id: @group.id, user_id:@user.id) }
      expect(Post.all.count).to eq(num+1)
    end
  end

  describe "update" do
    it "should be update if the user is the creator and the attributes are valid and should stay into post show view" do
      sign_in @user
      put "/groups/#{@group.id}/posts/#{@post.id}", :params => {:post => attributes_for(:post,title: "Updated", group_id: @group.id, user_id:@user.id) }
      follow_redirect!
      expect(response.body).to render_template("show")
      expect(response.body).to include("Post was successfully updated.")
    end
    it "should not be updated if the attributes aren't valid and should redirect into posts index" do
      sign_in @user
      put "/groups/#{@group.id}/posts/#{@post.id}", :params => {:post => attributes_for(:post,title: "", group_id: @group.id, user_id:@user.id) }
      follow_redirect!
      expect(response.body).to render_template("show")
      expect(response.body).to include("Not Possible to update.")
    end
    it "should not be update if the user is not the creator of the post, redirect to index" do
      sign_in @member_user
      put "/groups/#{@group.id}/posts/#{@post.id}", :params => {:post => attributes_for(:post,title: "Updated", group_id: @group.id, user_id:@user.id) }
      follow_redirect!
      expect(response.body).to render_template("index")
      expect(response.body).to include("Not Authorized")
    end
  end
  describe "destroy" do
    it "should be destroy if the user is the creator and redirect to index" do
      sign_in @user
      delete "/groups/#{@group.id}/posts/#{@post.id}"
      follow_redirect!
      expect(response.body).to render_template("index")
      expect(response.body).to include("Post was successfully destroyed.")
    end
    
    it "should not be destroy if the user is not the creator of the post, redirect to index" do
      sign_in @member_user
      delete "/groups/#{@group.id}/posts/#{@post.id}"
      follow_redirect!
      expect(response.body).to render_template("index")
      expect(response.body).to include("Not Authorized")
    end
    it "works and decrease the number of posts" do
      sign_in @user
      num=Post.all.count
      delete "/groups/#{@group.id}/posts/#{@post.id}"
      expect(Post.all.count).to eq(num-1)
    end

  end



end
