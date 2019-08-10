class User < PeakListRecord
  FILENAME = "users.yml"

  VALID_SORTS = {
    "username" => "Climber",
    "num_of_ascents" => "Number of Ascents"
  }

  class << self
    def file_path
      File.join(data_path, FILENAME)
    end

    def load_records
      PeakListRecord.load_records(file_path)
    end

    def load_users
      load_records
    end

    def sort_class_records(sort_by, rev)
      sort_records(sort_by, rev)
    end

    def load_user(username_input)
      users = load_users
      users.select { |user| user.username == username_input }.first
    end

    def load_user_by_id(userid_input)
      users = load_users
      users.select { |user| user.id == userid_input }.first
    end

    def invalid_signup_message(signup_data)
      if signup_data[:username].empty?
        "Username is invalid."
      elsif signup_data[:username] =~ /\W/
        "Username may contain letters, numbers and underscores only."
      elsif load_user(signup_data[:username])
        "Username already exists."
      elsif signup_data[:pass1] != signup_data[:pass2]
        "Passwords do not match."
      elsif signup_data[:pass1].size < 5
        "Passwords must be at least 5 characters."
      end
    end

    def create_new_user(data)
      user = new(data[:username])
      user.password = data[:pass1]
      user.write_to_users_file
    end

    def invalid_signin_message(signin_data)
      user = load_user(signin_data[:username])
      if !user
        "Username does not exist."
      elsif !user.valid_password?(signin_data[:password])
        "Wrong password."
      end
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
    if username == :no_user
      "Username does not exist."
    elsif !valid_password?
      "Wrong password."
    end
  end

  def valid_password?
    bcryt_password_obj = BCrypt::Password.new(password_hash)
    bcryt_password_obj == input_password
  end

  # def num_of_ascents
  #   user_ascents.count
  # end

  # def num_of_peaks
  #   unique_peaks.count
  # end

  def unique_peaks
    user_ascents.uniq(&:peakid).sort_by do |ascent|
      ascent.peak.elevation
    end.reverse
  end

  # def user_ascents
  #   ascents = Ascent.load_ascents
  #   ascents.select { |ascent| ascent.userid == @id }.sort_by(&:date).reverse
  # end

  def write_to_users_file
    write_to_records_file
  end
end
