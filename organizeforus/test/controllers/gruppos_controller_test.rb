require "test_helper"

class GrupposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gruppo = gruppos(:one)
  end

  test "should get index" do
    get gruppos_url
    assert_response :success
  end

  test "should get new" do
    get new_gruppo_url
    assert_response :success
  end

  test "should create gruppo" do
    assert_difference("Gruppo.count") do
      post gruppos_url, params: { gruppo: { descrizione: @gruppo.descrizione, nome: @gruppo.nome } }
    end

    assert_redirected_to gruppo_url(Gruppo.last)
  end

  test "should show gruppo" do
    get gruppo_url(@gruppo)
    assert_response :success
  end

  test "should get edit" do
    get edit_gruppo_url(@gruppo)
    assert_response :success
  end

  test "should update gruppo" do
    patch gruppo_url(@gruppo), params: { gruppo: { descrizione: @gruppo.descrizione, nome: @gruppo.nome } }
    assert_redirected_to gruppo_url(@gruppo)
  end

  test "should destroy gruppo" do
    assert_difference("Gruppo.count", -1) do
      delete gruppo_url(@gruppo)
    end

    assert_redirected_to gruppos_url
  end
end
