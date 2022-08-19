require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @user=users(:one)
  end


  test "shoud enter into profile" do
    get
  end
end
