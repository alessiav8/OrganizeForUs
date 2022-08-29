require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
begin
  test "visiting the index" do
     visit new_user_registration_path

     fill_in "Name", with: "al"
     fill_in "Surname", with: "V"
     fill_in "Username", with: "alex"
     fill_in "Email", with: "al@gm.com"
     fill_in "Birthday", with: "17/07/2022"
     fill_in "Password", with: "ciaociao"
     fill_in "Password confirmation", with: "ciaociao"
     click_on "Sign up"
  #
  #   assert_selector "h1", text: "Users"
  end
end
 
  
end
