class Ascent < PeakListRecord
  VALID_SORTS = {
    "user_name" => "Climber",
    "peak_name" => "Peak",
    "date" => "Date"
  }
  
  REVERSE_SORTS = []

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
    
    def make_object(tuple)
      ascent = new(tuple["id"].to_i,
                          tuple["user_id"].to_i,
                          tuple["peak_id"].to_i)
      ascent.date = Date.parse(tuple["date"])
      ascent.note = tuple["note"]
      ascent.user_name = tuple["user_name"]
      ascent.peak_name = tuple["peak_name"]
      ascent.elevation = tuple["elevation"].to_i
      
      ascent
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
