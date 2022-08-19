require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one) #ha fatto il secondo gruppo
    @group = groups(:two)
  end

  test "should get index" do
    get groups_url
    assert_response :success
  end

  test "should get new" do
    sign_in users(:one)
    get new_group_url
    assert_response :success
  end

  test "should create group" do
    sign_in users(:one)
    assert_difference("Group.count") do
      post groups_url, params: { group: { description: @group.description, name: @group.name, fun: @group.fun, work: @group.work, user_id: users(:one),created: @group.created } }
    end
    get group_url(Group.last)
    assert_response :success

  end

  test "should show group" do
    sign_in users(:one)
    get group_url(@group)
    assert_response :redirect
  end

  test "should not show group" do
    sign_out users(:one)
    sign_in users(:two)
    get group_url(@group)
    assert_redirected_to root_path
  end 

  test "should get edit" do
    get edit_group_url(@group)
    assert_response :redirect
  end

  test "should update group" do
    patch group_url(@group), params: { group: { description: @group.description, name: @group.name } }
    get group_url(@group)
  end



  test "should destroy group" do
    sign_out users(:two)
    sign_in users(:one)
    assert_difference("Group.count", -1) do
      delete group_url(@group)
    end
    get groups_url
  end
end
