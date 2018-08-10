require 'test_helper'

class StaticPagesTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user = users(:michael)
  end
    
  test "show home" do
    log_in_as(@user)
    get root_path
    
    assert_template 'static_pages/home'
    
    assert_select 'h1', text: @user.name
    assert_select 'img.gravatar'
    assert_match @user.microposts.count.to_s, response.body 
    assert_select 'div.pagination', count: 1
    # @user.microposts.paginate(page: 1).each do |micropost|
    #   assert_match micropost.content, response.body
    # end
    
    assert_select 'strong#following', "#{@user.following.count}"
    assert_select 'strong#followers', "#{@user.followers.count}"
  end
end
