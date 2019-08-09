class Peak < PeakListRecord
  FILENAME = "14ers.yml"

  VALID_SORTS = {
    "name_sort" => "Name",
    "elevation" => "Elevation",
    "prominence" => "Prominence",
    "isolation" => "Isolation",
    "parent_sort" => "Parent",
    "county" => "County",
    "state" => "State",
    "quad" => "Quadrangle"
  }

  REVERSE_SORTS = [
    "prominence",
    "elevation",
    "isolation"
  ]

  class << self
    def file_path
      File.join(data_path, "data", FILENAME)
    end

    def load_peaks
      load_records
    end

    def load_records
      PeakListRecord.load_records(file_path)
    end

    def load_peak_by_id(id)
      load_record_by_id(id)
    end

    def sort_class_records(sort_by, rev)
      if REVERSE_SORTS.include?(sort_by)
        rev = rev == false
      end

      sort_records(sort_by, rev)
    end
  end

  attr_reader :id
  attr_accessor :elevation, :prominence, :isolation, :county, :quad, :state

  def initialize(id)
    @id = id
  end

  def name
    remove_commas_swap(@name)
  end

  def name_sort
    @name
  end

  def parent
    remove_commas_swap(@parent)
  end

  def parent_sort
    @parent
  end

  def elevation_str
    add_commas(@elevation)
  end

  def prominence_str
    add_commas(@prominence)
  end

  def ascents
    result = Ascent.load_ascents
    result.select { |ascent| ascent.peakid == @id }
  end

  def num_ascents
    ascents.count
  end

  def num_ascents_by_user(user)
    return nil unless user
    result = ascents.select { |ascent| ascent.userid == user.id }.count
    result > 0 ? result : nil
  end

  def num_ascents_by_user_message(user)
    num_ascents = num_ascents_by_user(user)
    return if !num_ascents || num_ascents == 0

    ascent_str = num_ascents > 1 ? "ascents" : "ascent"
    "You have logged #{num_ascents} #{ascent_str}."
  end

  private

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
