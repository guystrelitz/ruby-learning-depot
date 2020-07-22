require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_url
    assert_response :success
  end

  test 'should log in' do
    susannah = users :susannah
    post login_url, params: { name: susannah.name, password: 'secret' }
    assert_redirected_to admin_url
    assert_equal susannah.id, session[:user_id]
  end

  test 'should fail login' do
    susannah = users :susannah
    post login_url, params: { name: susannah.name, password: 'wrong' }
    assert_redirected_to login_url
    assert_nil session[:user_id]
  end

  test 'should log out' do
    delete logout_url
    assert_redirected_to store_index_url
  end

end
