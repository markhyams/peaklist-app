require 'sinatra'
require "sinatra/reloader" if development?
require "tilt/erubis"
require 'yaml'
require 'bcrypt'
require 'date'

require_relative "peaklistrecord"
require_relative "peak"
require_relative "user"
require_relative "ascent"

configure do
  enable :sessions
  set :session_secret, "secret"
  # Use for more security: ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
end

helpers do
  def h(content)
    Rack::Utils.escape_html(content)
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

class FilePersistence
  attr_reader :ascent_class, :user_class, :peak_class
  
  CLASSES = {
    peak: Peak,
    ascent: Ascent,
    user: User
  }
  
  def initialize
    @ascent_class = Ascent
    @user_class = User
    @peak_class = Peak
  end
  
  def create_sort_links(params, class_sym)
    CLASSES[class_sym].create_sort_links(params)
  end
end

before do
  @storage = FilePersistence.new
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

  @sort_links = @storage.create_sort_links(params, :peak)
  @peaks = @storage.peak_class.sort_peaks(sort_by, reverse)
  erb :peaks
end

get "/ascents" do
  params[:sort] ||= "reverse" unless params[:sort_by]
  params[:sort_by] ||= "date"

  reverse = params[:sort] == "reverse"

  @sort_links = Ascent.create_sort_links(params)
  @ascents = Ascent.sort_ascents(params[:sort_by], reverse)
  erb :ascents
end

get "/users" do
  reverse = params[:sort] == "reverse"

  @sort_links = User.create_sort_links(params)
  @users = User.sort_users(params[:sort_by], reverse)
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
    User.create_new_user(signup_data)
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

  invalid_message = User.invalid_signin_message(signin_data)
  if invalid_message
    alert_message(invalid_message, "danger")
    status 422
    erb :signin
  else
    session[:user] = User.load_user(signin_data[:username])
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
  @user = User.load_user_by_id(params[:userid].to_i)

  if !@user
    alert_message("User does not exist.", "danger")
    redirect "/users"
  else
    @ascents = @user.user_ascents
    @unique_ascents = @user.unique_peaks
    erb :user
  end
end

get "/ascents/:ascentid" do
  @ascent = Ascent.load_record_by_id(params[:ascentid].to_i)

  if !@ascent
    alert_message("Ascent does not exist.", "danger")
    redirect "/ascents"
  else
    erb :ascent
  end
end

get "/ascents/:ascentid/edit" do
  require_signed_in_user

  @ascent = Ascent.load_record_by_id(params[:ascentid].to_i)

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
    Ascent.edit_ascent(ascent_data)
    alert_message("Ascent edited.")
    redirect "/ascents/#{params[:ascentid]}"
  end
end

post "/ascents/:ascentid/delete" do
  require_signed_in_user

  Ascent.delete_ascent(params[:ascentid].to_i)
  alert_message("Ascent deleted.")
  redirect "/users/#{session[:user].id}"
end

get "/ascents/add_ascent/:peak_id" do
  require_signed_in_user

  @peak = Peak.load_peak_by_id(params[:peak_id].to_i)

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

  @peak = Peak.load_peak_by_id(ascent_data[:peak_id])
  message = Ascent.invalid_message(ascent_data)
  # if !@peak
  #   alert_message("Peak does not exist.", "danger")
  #   status 422
  #   redirect "/"
  if message
    alert_message(message, "danger")
    status 422
    erb :add_ascent
  else
    Ascent.create_new_ascent(ascent_data)
    alert_message("Ascent of #{@peak.name} added.")
    redirect "/peaks"
  end
end

get "/peaks/:peakid" do
  @peak = Peak.load_peak_by_id(params[:peakid].to_i)

  erb :peak
end

get "/cancel_save" do
  alert_message("Data not saved.", "danger")
  redirect "/"
end
