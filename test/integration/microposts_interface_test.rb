require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  
  test "should login, show feed, post, delete, and check other users' posts" do
    # login
    log_in_as(@user)
    
    # pagination
    get root_url
    assert_template 'static_pages/home'
    assert_select 'div.pagination', count: 1
    first_page_of_microposts = @user.feed.paginate(page: 1)
    first_page_of_microposts.each do |micropost|
      assert_select 'a[href=?]', user_path(@user), text: @user.name
      assert_select 'a[href=?]', micropost_path(micropost), text: 'delete'
    end
    
    # invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: 'a' * 141 } }
    end
    # assert_not flash.empty?
    assert_template 'static_pages/home'
    assert_select 'div#error_explanation'
    
    # valid submission
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: "asume post" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    
    # delete micropost
     assert_difference 'Micropost.count', -1 do
      delete micropost_path(@user.microposts.first)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    
    # check other user's profile
    @other = users(:archer)
    get user_path(@other)
    assert_template 'users/show'
    assert_select  'a[href=?]', user_path(@other), text: 'delete', count: 0
  end
end
