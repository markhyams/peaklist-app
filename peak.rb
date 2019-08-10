class Peak < PeakListRecord
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

  attr_reader :id
  attr_accessor :elevation, :prominence, :isolation, :county, :quad, :state, :num_ascents, :ascents

  def initialize(id)
    @id = id
  end

  def name
    remove_commas_swap(@name)
  end
  
  def name=(n)
    @name = n
  end

  def name_sort
    @name
  end

  def parent
    remove_commas_swap(@parent)
  end
  
  def parent=(parent_input)
    @parent = parent_input
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
