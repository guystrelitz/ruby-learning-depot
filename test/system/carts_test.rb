require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  setup do
    @cart = carts(:one)
  end

  test "visiting the index" do
    visit carts_url
    assert_selector "h1", text: "Carts"
  end

  test "creating a Cart" do
    visit carts_url
    click_on "New Cart"

    click_on "Create Cart"

    assert_text "Cart was successfully created"
    click_on "Empty cart"
  end

  test "updating a Cart" do
    visit carts_url
    click_on "Edit", match: :first

    click_on "Update Cart"

    assert_text "Cart was successfully updated"
    click_on "Empty cart"
  end

  test "destroying a Cart" do
    visit carts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    # redirected back to the homepage
    assert_current_path store_index_path
  end
end
