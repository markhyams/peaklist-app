# require "simplecov"
# SimpleCov.start

ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"

require_relative "../peak_list"

class PeakListTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def session
    last_request.env["rack.session"]
  end

  def admin_session
    { "rack.session" => { user: User.new(5, "mark") } }
  end

  def query_database(sql, *params)
    db = DatabasePersistence.new(database_name)
    db.query(sql, *params)
    db.disconnect
  end

  def delete_created_user(username)
    sql = "DELETE FROM users WHERE username = $1";  
    query_database(sql, username)
  end
  
  def delete_created_ascent(note)
    sql  = "DELETE FROM ascents WHERE note = $1"
    query_database(sql, note)
  end
  
  def test_index
    get "/peaks"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Mount Elbert"
  end

  def test_add_user
    signup_data = {
      username: "test_signin_user",
      password1: "secret",
      password2: "secret"
    }
    post "/users/signup", signup_data

    assert_equal "You have signed up successfully.", session[:message][:text]
    assert_equal 302, last_response.status

    delete_created_user(signup_data[:username])
    # julia = User.load_user("julia")
    # assert_equal 1, julia.id
  end

  def test_login
    post "/users/signin", username: "mark", password: "hello"
    assert_equal 302, last_response.status
    assert session[:user]
    assert_equal "You have logged in successfully.", session[:message][:text]
    get "/peaks"
    assert_includes last_response.body, "Signed in as"
  end

  def test_login_wrong_username
    post "/users/signin", username: "admin", password: "hello"
    assert_equal 422, last_response.status
    assert_includes last_response.body, "Username does not exist."
  end

  def test_wrong_password
    post "/users/signin", username: "mark", password: "ssshh"
    assert_equal 422, last_response.status
    assert_includes last_response.body, "Wrong password."
  end

  def test_logout
    get "/users/signout", {}, admin_session
    assert_equal 302, last_response.status
    assert_nil session[:user]
    assert_equal "You have logged out successfully.", session[:message][:text]
  end

  def test_add_user_invalid_username
    post "/users/signup", username: "", password1: "secret", password2: "secret"
    assert_equal 422, last_response.status
    assert_includes last_response.body, "Username is invalid"
  end

  def test_add_user_passwords_dont_match
    signup_data = {
      username: "test_user",
      password1: "secret1",
      password2: "secret"
    }

    post "/users/signup", signup_data
    assert_equal 422, last_response.status
    assert_includes last_response.body, "Passwords do not match."
  end

  def test_add_user_password_not_valid
    post "/users/signup", username: "test_user", password1: "ssh", password2: "ssh"
    assert_equal 422, last_response.status
    alert_message = "Passwords must be at least 5 characters."
    assert_includes last_response.body, alert_message
  end

  def test_load_signin_page
    get "/users/signin"
    assert_equal 200, last_response.status
  end

  def test_load_signup_page
    get "/users/signup"
    assert_equal 200, last_response.status
  end

  def test_add_ascent
    ascent_data = {
      date: "2014-07-18",
      note: "test_ascent_fjdskl9334fdk23431"
    }
    post "/ascents/add_ascent/1", ascent_data, admin_session

    assert_equal 302, last_response.status
    assert_equal "Ascent of Mount Elbert added.", session[:message][:text]
    
    delete_created_ascent(ascent_data[:note])

    # get "ascents/8"
    # assert_equal 200, last_response.status
    # assert_includes last_response.body, "overwrite"
  end

  def test_add_ascent_invalid_date
    post "/ascents/add_ascent/1", { date: "2001-02-29" }, admin_session

    assert_equal 422, last_response.status
    assert_includes last_response.body, "Invalid date."
  end

  def test_ascent_note
    get "ascents/55"

    assert_equal 200, last_response.status
    assert_includes last_response.body, "overwrite"
  end

  def test_user_page
    get "users/5"

    assert_equal 200, last_response.status
    assert_includes last_response.body, "mark"
    # assert_includes last_response.body, ">8</span></h4"
    # assert_includes last_response.body, ">1</span></h4"
  end

  def test_must_be_signed_in
    get "/ascents/add_ascent/1"

    assert_equal 302, last_response.status
    assert_equal "You must be signed in to do that.", session[:message][:text]
  end

  def test_sort_peaks_by_name
    get "/peaks?sort_by=name"

    text = <<~HTML.chomp
      href="/peaks?sort_by=name&sort=reverse">
    HTML

    assert_equal 200, last_response.status
    assert_includes last_response.body, text
  end

  def test_sort_peaks_by_name_reverse
    get "/peaks?sort_by=name&sort=reverse"

    text = <<~HTML.chomp
      href="/peaks?sort_by=name">
    HTML

    assert_equal 200, last_response.status
    assert_includes last_response.body, text
  end

  def test_users_page
    get "/users"

    assert_equal 200, last_response.status
    assert_includes last_response.body, "mark"
  end

  def test_ascent_notes_page
    get "/ascents"

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Mount Elbert"
  end

  def test_home_page
    get "/"

    assert_equal 302, last_response.status
  end

  def test_user_does_not_exist
    get "/users/100"

    assert_equal 302, last_response.status
    assert_equal "User does not exist.", session[:message][:text]
  end

  def test_add_ascent_page
    get "/ascents/add_ascent/1", {}, admin_session

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Mount Elbert"
  end

  def test_add_ascent_invalid_peak
    get "/ascents/add_ascent/999999", {}, admin_session

    assert_equal 302, last_response.status
    assert_equal "Peak does not exist.", session[:message][:text]
  end

  def test_ascent_invalid_ascent
    get "/ascents/999999"

    assert_equal 302, last_response.status
    assert_equal "Ascent does not exist.", session[:message][:text]
  end

  def test_edit_ascent_page
    get "/ascents/55/edit", {}, admin_session

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Mount Columbia"
  end

  def test_edit_ascent_page_post
    ascent_data = {
      date: "2014-07-18",
      note: "test_ascent_fdsf293143jfal39"
    }
    post "/ascents/add_ascent/1", ascent_data, admin_session

    post "ascents/55/edit", { date: "2014-07-18", note: "overwrite again" }
    get last_response["Location"]
    assert_includes last_response.body, "overwrite again"
    delete_created_ascent(ascent_data[:note])
  end

  # def test_delete_ascent
  #   ascent_data = {
  #     date: "2014-07-18",
  #     note: "test_note_fdjf93jnsd93fwfsd"
  #   }
  #   post "/ascents/add_ascent/1", ascent_data, admin_session

  #   post "ascents/8/delete"
  #   get last_response["Location"]
  #   assert_includes last_response.body, "Ascent deleted."

  #   get "users/5"

  #   assert_equal 200, last_response.status
  #   # assert_includes last_response.body, ">8</span></h4"
    
  # end

  def test_peak_page
    get "/peaks/1", {}, admin_session

    assert_equal 200, last_response.status
    # assert_includes last_response.body, "You have logged 7 ascents."
  end
end
