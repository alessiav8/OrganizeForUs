require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @post = posts(:one)
    @group= groups(:two)

  end
  test "should get index" do
    get group_posts_url(@group)
    assert_response :success
  end
end
