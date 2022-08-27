require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user=users(:one)
  end

  test "should log in" do
    get new_user_session_path
    assert_response :success
    assert_difference("User.count") do
      post user_session_url, params: { user: { name: @user.name, surname: @user.surname, birthday:@user.birthday, email: @user.email} }
    end
    assert_response :success
  end


end
