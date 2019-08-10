require 'sinatra'
require "tilt/erubis"
require 'yaml'
require 'bcrypt'
require 'date'

require_relative "peaklistrecord"
require_relative "peak"
require_relative "user"
require_relative "ascent"
require_relative "database_persistence"

configure do
  enable :sessions
  set :session_secret, "secret"
  # Use for more security: ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
end

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
  also_reload "peaklistrecord.rb"
  also_reload "peak.rb"
  also_reload "user.rb"
  also_reload "ascent.rb"
end


helpers do
  def h(content)
    Rack::Utils.escape_html(content)
  end
  
  def remove_commas_swap(str)
    return str unless str.include?(",")
    str.split(", ").reverse.join(" ")
  end

  def add_commas(int)
    reversed_num_str = int.to_s.chars.reverse
    result = []
    reversed_num_str.each_with_index do |num, index|
      result << "," if index % 3 == 0 && index > 0
      result << num
    end
    result.reverse.join("")
  end
end

def alert_message(text, type="success")
  session[:message] = {
    text: text,
    type: type
  }
end

def data_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test", __FILE__)
  else
    File.expand_path("../", __FILE__)
  end
end

before do
  @storage = DatabasePersistence.new
end 

after do
  @storage.disconnect
end

def user_signed_in?
  session.key?(:user)
end

def require_signed_in_user
  return if user_signed_in?
  alert_message("You must be signed in to do that.", "danger")
  redirect "/"
end

get "/" do
  redirect "/peaks"
end

get "/peaks" do
  sort_by = params[:sort_by] ||= "elevation"
  reverse = params[:sort] == "reverse"

  @sort_links = Peak.create_sort_links(params)
  @peaks = @storage.load_peaks_sorted(sort_by, reverse)
  erb :peaks
end

get "/ascents" do
  reverse = params[:sort] ||= "reverse" unless params[:sort_by]
  sort_by = params[:sort_by] ||= "date"

  reverse = params[:sort] == "reverse"

  @sort_links = Ascent.create_sort_links(params)
  @ascents = @storage.load_ascents_sorted(sort_by, reverse)
  erb :ascents
end

get "/users" do
  reverse = params[:sort] == "reverse"
  sort_by = params[:sort_by]

  @sort_links = User.create_sort_links(params)
  @users = @storage.load_users_sorted(sort_by, reverse)
  erb :users
end

get "/users/signup" do
  erb :signup
end

post "/users/signup" do
  signup_data = {
    username: params[:username].strip,
    pass1: params[:password1],
    pass2: params[:password2]
  }

  invalid_message = User.invalid_signup_message(signup_data)
  if invalid_message
    alert_message(invalid_message, "danger")
    status 422
    erb :signup
  else
    @storage.create_new_user(signup_data)
    alert_message("You have signed up successfully.")
    redirect "/"
  end
end

get "/users/signin" do
  erb :signin
end

post "/users/signin" do
  signin_data = {
    username: params[:username],
    password: params[:password]
  }
  
  user = @storage.load_user_by_username(signin_data)

  invalid_message = user.invalid_signin_message
  if invalid_message
    alert_message(invalid_message, "danger")
    status 422
    erb :signin
  else
    session[:user] = user
    alert_message("You have logged in successfully.")
    redirect "/"
  end
end

get "/users/signout" do
  session.delete(:user)
  alert_message("You have logged out successfully.")
  redirect "/"
end

get "/users/:userid" do
  @user = @storage.load_user_by_id(params[:userid].to_i)

  if !@user
    alert_message("User does not exist.", "danger")
    redirect "/users"
  else
    @ascents = @storage.load_ascents_by_userid(@user.id)
    @unique_ascents = @storage.load_peaks_by_user(@user)
    erb :user
  end
end

get "/ascents/:ascentid" do
  @ascent = @storage.load_ascent_by_id(params[:ascentid].to_i)

  if !@ascent
    alert_message("Ascent does not exist.", "danger")
    redirect "/ascents"
  else
    erb :ascent
  end
end

get "/ascents/:ascentid/edit" do
  require_signed_in_user

  @ascent = @storage.load_ascent_by_id(params[:ascentid].to_i)

  if session[:user].id != @ascent.user.id
    alert_message("This is not your ascent.", "danger")
    redirect "/ascents/#{params[:ascentid]}"
  else
    erb :edit_ascent
  end
end

post "/ascents/:ascentid/edit" do
  require_signed_in_user

  ascent_data = {
    ascent_id: params[:ascentid].to_i,
    user_id: session[:user].id,
    date: params[:date].strip,
    note: params[:note].to_s.strip
  }

  message = Ascent.invalid_message(ascent_data, :edit)
  if message
    alert_message(message, "danger")
    status 422
    erb :edit_ascent
  else
    @storage.edit_ascent(ascent_data)
    alert_message("Ascent edited.")
    redirect "/ascents/#{params[:ascentid]}"
  end
end

post "/ascents/:ascentid/delete" do
  require_signed_in_user

  @storage.delete_ascent(params[:ascentid].to_i)
  alert_message("Ascent deleted.")
  redirect "/users/#{session[:user].id}"
end

get "/ascents/add_ascent/:peak_id" do
  require_signed_in_user

  @peak = @storage.load_peak_by_id(params[:peak_id].to_i)

  if !@peak
    alert_message("Peak does not exist.", "danger")
    status 422
    redirect "/"
  else
    erb :add_ascent
  end
end

post "/ascents/add_ascent/:peak_id" do
  require_signed_in_user

  ascent_data = {
    peak_id: params[:peak_id].to_i,
    user_id: session[:user].id,
    date: params[:date].strip,
    note: params[:note].to_s.strip
  }

  @peak = @storage.load_peak_by_id(params[:peak_id].to_i)
  message = Ascent.invalid_message(ascent_data)

  if message
    alert_message(message, "danger")
    status 422
    erb :add_ascent
  else
    @storage.create_ascent(ascent_data)
    alert_message("Ascent of #{@peak.name} added.")
    redirect "/peaks"
  end
end

get "/peaks/:peakid" do
  @peak = @storage.load_peak_by_id(params[:peakid].to_i)

  erb :peak
end

get "/cancel_save" do
  alert_message("Data not saved.", "danger")
  redirect "/"
end
