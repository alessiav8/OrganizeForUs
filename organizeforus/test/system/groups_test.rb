require "application_system_test_case"

class GroupsTest < ApplicationSystemTestCase
  setup do
    sign_in User.last
    @group = groups(:two)
  end

  test "visiting the index" do #funziona
    visit groups_url
  end

  test "should create group" do #funziona
    visit groups_url
    click_on "Create new group"

    fill_in "Description", with: @group.description
    fill_in "Name", with: @group.name
    click_on "Continue"

    fill_in "Enter user email", with: users(:one).email
    click_on "End"
    assert_text "Group was successfully created"
  end

  test "should update group" do
    sign_in users(:one)
    visit edit_group_url(@group)  
    fill_in "Name", with: "Updated"
    click_on "Update"
    assert_text "Group was successfully updated"
  end








  
end
