require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user=users(:one)
  end

  test "should sign up" do
    get new_user_registration_path
    assert_response :success
    assert_difference("User.count") do
      post user_registration_path, params: { user: { name: "Esempio", surname: "Esempio cognome", birthday: @user.birthday, email: "esempio@gmail.com", username: "Username",password:"password"} }
    end
  end


end
