require 'pg'

class DatabasePersistence
  def initialize(db_name)
    @db = PG.connect(dbname: db_name)
  end

  def query(sql, *params)
    # puts sql
    # puts params
    @db.exec_params(sql, params)
  end

  def disconnect
    @db.close
  end

  def make_peak_object(tuple)
    id = tuple["id"].to_i

    peak = Peak.make_object(tuple)
    peak.num_ascents = num_ascents_of_peak(id)
    peak.ascents = load_ascents_by_peakid(id)

    peak
  end

  def make_ascent_object(tuple)
    Ascent.make_object(tuple)
  end

  def make_user_object(tuple)
    user = User.make_object(tuple)
    user.num_of_peaks = num_peaks_by_user(tuple["id"].to_i)

    user
  end

  def num_peaks_by_user(user_id)
    sql = "SELECT count(DISTINCT peak_id) FROM ascents WHERE user_id = $1;"
    query(sql, user_id).first["count"].to_i
  end

  def num_ascents_of_peak(peak_id)
    sql = "SELECT count(id) FROM ascents WHERE peak_id = $1;"
    query(sql, peak_id).first["count"].to_i
  end

  def load_peaks_sorted(sort_by, reverse)
    order = Peak.order_by_str(sort_by, reverse)
    sql = "SELECT * FROM peaks ORDER BY #{order};"
    result = query(sql)
    result.map do |peak_record|
      make_peak_object(peak_record)
    end
  end

  def load_ascents_sorted(sort_by, reverse)
    order = Ascent.order_by_str(sort_by, reverse)
    sql = <<~SQL
      SELECT
      peaks.name AS peak_name,
      peaks.elevation,
      ascents.*,
      users.username AS user_name
      FROM ascents INNER JOIN users
      ON ascents.user_id = users.id
      INNER JOIN peaks
      ON peaks.id = ascents.peak_id
      ORDER BY #{order};
    SQL
    result = query(sql)

    result.map do |ascent_record|
      make_ascent_object(ascent_record)
    end
  end

  def load_users_sorted(sort_by, reverse)
    order = User.order_by_str(sort_by, reverse)
    sql = <<~SQL
      SELECT users.id, users.username,
      COALESCE( (SELECT count(id) FROM ascents
      WHERE user_id = users.id GROUP BY user_id), 0)
      AS num_of_ascents FROM users
      ORDER BY #{order};
    SQL
    result = query(sql)

    result.map do |user_record|
      make_user_object(user_record)
    end
  end

  def add_new_user(data)
    new_user = User.create_temp_user(data)
    sql = "INSERT INTO users (username, password) VALUES ($1, $2);"

    query(sql, new_user.username, new_user.password)
  end

  def load_user_from_input(data)
    sql = "SELECT * FROM users WHERE username = $1"
    result = query(sql, data[:username]).first
    return User.new(0, :no_user) unless result

    user = User.new(result["id"].to_i, result["username"])
    user.input_password = data[:password]
    user.password_hash = result["password"]

    user
  end

  def load_user_by_id(id)
    sql = "SELECT * FROM users WHERE id = $1"
    result = query(sql, id)
    return nil if result.ntuples == 0
    make_user_object(result.first)
  end

  def load_peak_by_id(id)
    sql = "SELECT * FROM peaks WHERE id = $1"
    result = query(sql, id)

    return nil if result.ntuples == 0;
    make_peak_object(result.first)
  end

  def load_ascents_by_userid(id)
    sql = <<~SQL
      SELECT
      peaks.name AS peak_name,
      peaks.elevation,
      ascents.*
      FROM ascents INNER JOIN peaks
      ON peaks.id = ascents.peak_id
      WHERE ascents.user_id = $1;
    SQL
    result = query(sql, id)

    result.map do |ascent_record|
      make_ascent_object(ascent_record)
    end
  end

  def load_ascents_by_peakid(id)
    sql = "SELECT * FROM ascents WHERE peak_id = $1"
    sql = <<~SQL
      SELECT ascents.*, users.username AS user_name
      FROM ascents INNER JOIN users
      ON ascents.user_id = users.id
      WHERE ascents.peak_id = $1;
    SQL
    result = query(sql, id)

    result.map do |ascent_record|
      make_ascent_object(ascent_record)
    end
  end

  def load_peaks_by_user(user)
    sql = <<~SQL
    SELECT DISTINCT ascents.peak_id, peaks.name, peaks.elevation FROM ascents INNER JOIN peaks
    ON ascents.peak_id = peaks.id
    WHERE user_id = $1;
    SQL
    result = query(sql, user.id)

    result.map do |peak_record|
      make_peak_object(peak_record)
    end
  end

  def load_ascent_by_id(id)
    sql = <<~SQL
      SELECT
      peaks.name AS peak_name,
      peaks.elevation,
      ascents.*,
      users.username AS user_name
      FROM ascents INNER JOIN users
      ON ascents.user_id = users.id
      INNER JOIN peaks
      ON peaks.id = ascents.peak_id
      WHERE ascents.id = $1;
    SQL
    result = query(sql, id)

    return nil if result.ntuples == 0;
    make_ascent_object(result.first)
  end

  def edit_ascent(data)
    sql = "UPDATE ascents SET date = $1, note = $2 WHERE id = $3;"
    query(sql, data[:date], data[:note], data[:ascent_id])
  end

  def delete_ascent(id)
    sql = "DELETE FROM ascents WHERE id = $1"
    query(sql, id)
  end

  def create_ascent(data)
    sql = <<~SQL
      INSERT INTO ascents (user_id, peak_id, "date", note)
      VALUES ($1, $2, $3, $4)
    SQL
    values = [data[:user_id], data[:peak_id], data[:date], data[:note]]

    query(sql, *values)
  end
end
