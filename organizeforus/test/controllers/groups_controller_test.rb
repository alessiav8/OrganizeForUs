require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
  end

  test "should get index" do
    get groups_url
    assert_response :success
  end

  test "should get new" do
    get new_gruppo_url
    assert_response :success
  end

  test "should create group" do
    assert_difference("Group.count") do
      post groups_url, params: { group: { descrizione: @group.descrizione, nome: @group.nome } }
    end

    assert_redirected_to gruppo_url(Group.last)
  end

  test "should show group" do
    get gruppo_url(@group)
    assert_response :success
  end

  test "should get edit" do
    get edit_gruppo_url(@group)
    assert_response :success
  end

  test "should update group" do
    patch gruppo_url(@group), params: { group: { descrizione: @group.descrizione, nome: @group.nome } }
    assert_redirected_to gruppo_url(@group)
  end

  test "should destroy group" do
    assert_difference("Group.count", -1) do
      delete gruppo_url(@group)
    end

    assert_redirected_to groups_url
  end
end
