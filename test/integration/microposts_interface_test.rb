require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  
  test "should login, show feed, post, delete, and check other users' posts" do
    # login
    log_in_as(@user)
    
    # pagination
    get root_path
    assert_select 'div.pagination'

    # invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: 'a' * 141 } }
    end
    assert_select 'div#error_explanation'
    
    # valid submission
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    
    # delete micropost
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # check other user's profile
    @other = users(:archer)
    get user_path(@other)
    assert_select  'a', text: 'delete', count: 0
  end
end
