require "pg"
require "yaml"

require_relative "peaklistrecord"
require_relative "peak"
require_relative "user"
require_relative "ascent"

db = PG.connect(dbname: "peak_list")

# result = db.exec("SELECT * FROM peaks;")

# peak_objects = YAML.load_file("data/14ers.yml")

# sql = <<~SQL
#   INSERT INTO peaks (id, name, elevation, prominence, isolation, parent, county, quad, state) VALUES
#   ($1, $2, $3, $4, $5, $6, $7, $8, $9);
# SQL

# peak_objects.each do |peak|
#   data = [
#     peak.id,
#     peak.name_sort,
#     peak.elevation,
#     peak.prominence,
#     peak.isolation,
#     peak.parent_sort,
#     peak.county,
#     peak.quad,
#     peak.state
#     ]
#   db.exec_params(sql, data)
# end

# user_objects = YAML.load_file("users.yml")

# sql = <<~SQL
#   INSERT INTO users (id, username, password) VALUES
#   ($1, $2, $3);
# SQL

# user_objects.each do |user|
#   data = [
#     user.id,
#     user.username,
#     user.password
#     ]
#   db.exec_params(sql, data)
# end

ascent_objects = YAML.load_file("data/ascents.yml")

sql = <<~SQL
  INSERT INTO ascents (id, user_id, peak_id, "date", note) VALUES
  ($1, $2, $3, $4, $5);
SQL

ascent_objects.each do |ascent|
  data = [
    ascent.id,
    ascent.userid,
    ascent.peakid,
    ascent.date,
    ascent.note
    ]
  db.exec_params(sql, data)
end

db.close