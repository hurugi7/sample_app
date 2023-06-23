require "test_helper"

class SiteLayout < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
end

class SiteLayoutTest < SiteLayout

  test "layout links before login" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign up")
    get help_path
    assert_select "title", full_title("Help")
    get about_path
    assert_select "title", full_title("About")
    get login_path
    assert_select "title", full_title("Log in")
  end

  test "layout links after login" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    get contact_path
    assert_select "title", full_title("Contact")
    get user_path(@user)
    assert_select "title", full_title(@user.name)
    get help_path
    assert_select "title", full_title("Help")
    get about_path
    assert_select "title", full_title("About")
    get edit_user_path(@user)
    assert_select "title", full_title("Edit user")
  end

  test "static information should be right after login" do
    log_in_as(@user)
    get root_path
    assert_match @user.following.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body
  end
end
