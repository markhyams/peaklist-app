class Ascent < PeakListRecord
  VALID_SORTS = {
    "user_name" => "Climber",
    "peak_name" => "Peak",
    "date" => "Date"
  }

  class << self
    def invalid_message(data)
      peak = data[:peak]
      date_str = data[:date]
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

  attr_accessor :date, :note, :user_name, :peak_name, :elevation
  attr_reader :id, :userid, :peakid

  def initialize(id, userid, peakid)
    @userid = userid
    @peakid = peakid
    @id = id
  end

  def date_display
    @date.strftime("%A, %B %-d, %Y")
  end
end
