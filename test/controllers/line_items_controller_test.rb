require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  include CurrentCart

  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    follow_redirect!

    assert_select 'h2', 'Your Cart'
    assert_select 'nav td.quantity', 1
  end

  test "should create line_item via ajax" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }, xhr: true
    end

    assert_response :success
    assert_match /<tr class=\\"line-item-highlight\\">/, @response.body
  end

  test "should decrement line_item" do
    # add 2 items so we can then delete 1 and see the difference in quantity
    2.times do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    # we need the cart from the session – a fixture won't cut it
    follow_redirect!
    set_cart
    cart = Cart.find(session[:cart_id])

    # the number in the line item's quantity field should decrement
    diff_string = "css_select('#cart td.quantity')[0].content.to_i"
    assert_difference(diff_string, -1) do
      delete line_item_url(cart.line_items[0]), params: {remove_one: true}
      follow_redirect!
    end

    assert_select '#cart', 1
  end

  test "should decrement line_item via ajax" do
    # add 2 items so we can then delete 1 and see the difference in quantity
    2.times do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    # we need the cart from the session – a fixture won't cut it
    follow_redirect!
    set_cart
    cart = Cart.find(session[:cart_id])

    delete line_item_url(cart.line_items[0]), params: {remove_one: true}, xhr: true

    assert_response :success
    assert_match /<tr class=\\"line-item-highlight\\">/, @response.body
    assert_match /<td class=\\"quantity\\">1<\\\/td>/, @response.body
  end

  test "decrementing line_item to 0 should delete" do
    post line_items_url, params: { product_id: products(:one).id }
    post line_items_url, params: { product_id: products(:two).id }
    follow_redirect!

    # we need the cart from the session – a fixture won't cut it
    set_cart
    cart = Cart.find(session[:cart_id])

    # one of the line items should disappear, so its quantity field should go
    diff_string = "css_select('#cart td.quantity').count"
    assert_difference(diff_string, -1) do
      delete line_item_url(cart.line_items[0]), params: {remove_one: true}
      follow_redirect!
    end

    assert_select '#cart', 1
  end

  test "decrementing final line_item to 0 should make cart contents disappear" do
    post line_items_url, params: { product_id: products(:one).id }
    follow_redirect!

    # we need the cart from the session – a fixture won't cut it
    set_cart
    cart = Cart.find(session[:cart_id])

    # the final line item is removed, so the cart should disappear
    diff_string = "css_select('div#cart article').count"
    assert_difference(diff_string, -1) do
      delete line_item_url(cart.line_items[0]), params: {remove_one: true}
      follow_redirect!
    end

    assert_select 'div#cart article', 0
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to store_index_url
  end
end
