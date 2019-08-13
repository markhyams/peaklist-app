class User < PeakListRecord
  VALID_SORTS = {
    "username" => "Climber",
    "num_of_ascents" => "Number of Ascents"
  }
  
  REVERSE_SORTS = ["num_of_ascents"]

  class << self
    def create_temp_user(data)
      user = new(0, data[:username])
      user.password = data[:password]
      user
    end
    
    def make_object(tuple)
      user = new(tuple["id"].to_i, tuple["username"])
      user.num_of_ascents = tuple["num_of_ascents"]
      
      user
    end
  end

  attr_reader :password, :username, :id
  attr_accessor :num_of_ascents, :num_of_peaks, :input_password, :password_hash

  def initialize(id, username)
    @username = username
    @id = id
  end

  def password=(input)
    @password = BCrypt::Password.create(input).to_s
  end

  def invalid_signin_message
    if !exists?
      "Username does not exist."
    elsif !valid_password?
      "Wrong password."
    end
  end

  def valid_password?
    bcryt_password_obj = BCrypt::Password.new(password_hash)
    bcryt_password_obj == input_password
  end
  
  def invalid_signup_message(signup_data)
    if signup_data[:username].empty?
      "Username is invalid."
    elsif signup_data[:username] =~ /\W/
      "Username may contain letters, numbers and underscores only."
    elsif exists?
      "Username already exists."
    elsif signup_data[:password] != signup_data[:password_verify]
      "Passwords do not match."
    elsif signup_data[:password].size < 5
      "Passwords must be at least 5 characters."
    end
  end
  
  def exists?
    username != :no_user
  end
  
  def unique_peaks
    user_ascents.uniq(&:peakid).sort_by do |ascent|
      ascent.peak.elevation
    end.reverse
  end
end
