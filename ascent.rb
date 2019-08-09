class Ascent < PeakListRecord
  FILENAME = "ascents.yml"

  VALID_SORTS = {
    "user_name" => "Climber",
    "peak_name" => "Peak",
    "date" => "Date"
  }

  class << self
    def load_records
      PeakListRecord.load_records(file_path)
    end

    def load_ascents
      load_records
    end

    def file_path
      File.join(data_path, "data", FILENAME)
    end

    def create_new_ascent(data)
      ascent = new(data[:user_id], data[:peak_id])
      ascent.date = Date.parse(data[:date])
      ascent.note = data[:note]
      ascent.write_to_ascents_file
    end

    def edit_ascent(data)
      work_with_records do |ascents|
        idx = ascents.index { |ascent| ascent.id == data[:ascent_id] }
        ascent = ascents[idx]
        ascent.date = Date.parse(data[:date])
        ascent.note = data[:note]
      end
    end

    def delete_ascent(id)
      work_with_records do |ascents|
        ascents.delete_if { |ascent| ascent.id == id }
      end
    end

    def invalid_message(data, type = :add)
      date_str = data[:date]
      peak = Peak.load_peak_by_id(data[:peak_id])
      peak = true if type == :edit
      date = Date.parse(date_str)

      if !peak
        "Peak does not exist."
      elsif date > Date.today
        "Future dates cannot be logged."
      end

    rescue ArgumentError
      "Invalid date."
    end

    def sort_class_records(sort_by, rev)
      sort_records(sort_by, rev)
    end
  end

  attr_accessor :date, :note
  attr_reader :id, :userid, :peakid

  def initialize(userid, peakid)
    @userid = userid
    @peakid = peakid
    @id = next_id
  end

  def user
    User.load_user_by_id(@userid)
  end

  def user_name
    user.username
  end

  def peak_name
    peak.name
  end

  def peak
    Peak.load_peak_by_id(@peakid)
  end

  def date_display
    @date.strftime("%A, %B %-d, %Y")
  end

  def write_to_ascents_file
    write_to_records_file
  end
end
