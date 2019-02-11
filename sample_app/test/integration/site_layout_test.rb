require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:micheal)
  end

  test "layout links(not log in)" do
    get root_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign up")
    # static links
    assert_select "a[href=?]", "http://news.railstutorial.org/"
    assert_select "a[href=?]", "https://railstutorial.jp/"
    assert_select "a[href=?]", "http://www.michaelhartl.com/"
 end

  test "layout links(log in)" do
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    # static links
    assert_select "a[href=?]", "http://news.railstutorial.org/"
    assert_select "a[href=?]", "https://railstutorial.jp/"
    assert_select "a[href=?]", "http://www.michaelhartl.com/"
  end
end
