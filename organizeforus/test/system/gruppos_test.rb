require "application_system_test_case"

class GrupposTest < ApplicationSystemTestCase
  setup do
    @gruppo = gruppos(:one)
  end

  test "visiting the index" do
    visit gruppos_url
    assert_selector "h1", text: "Gruppos"
  end

  test "should create gruppo" do
    visit gruppos_url
    click_on "New gruppo"

    fill_in "Descrizione", with: @gruppo.descrizione
    fill_in "Nome", with: @gruppo.nome
    click_on "Create Gruppo"

    assert_text "Gruppo was successfully created"
    click_on "Back"
  end

  test "should update Gruppo" do
    visit gruppo_url(@gruppo)
    click_on "Edit this gruppo", match: :first

    fill_in "Descrizione", with: @gruppo.descrizione
    fill_in "Nome", with: @gruppo.nome
    click_on "Update Gruppo"

    assert_text "Gruppo was successfully updated"
    click_on "Back"
  end

  test "should destroy Gruppo" do
    visit gruppo_url(@gruppo)
    click_on "Destroy this gruppo", match: :first

    assert_text "Gruppo was successfully destroyed"
  end
end
