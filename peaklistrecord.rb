class PeakListRecord
  class << self
    # def load_records(file_path)
    #   YAML.load_file(file_path)
    # end

    def create_sort_links(params)
      result = []
      self::VALID_SORTS.each do |param_name, name|
        rev = "&sort=reverse"
        rev = "" unless params[:sort_by] == param_name && !params[:sort]

        html = "<a class=\"text-secondary\" href=\"/#{page_name}" \
               "?sort_by=#{param_name}#{rev}\">#{name}</a>"
        result << html
      end
      result
    end

    def work_with_records
      path = file_path
      records = load_records
      yield(records)
      File.open(path, "w") { |f| f.write(records.to_yaml) }
    end

    def sort_records(sort_by, rev)
      records = load_records
      return records unless self::VALID_SORTS.keys.include?(sort_by)
      sort_sym = sort_by.to_sym

      result = records.sort_by(&sort_sym)

      rev ? result.reverse : result
    end

    def load_record_by_id(id)
      records = load_records
      records.select { |record| record.id == id }.first
    end

    def page_name
      to_s.downcase + "s"
    end
  end

  def write_to_records_file
    new_data = self
    self.class.work_with_records do |records|
      records ||= []
      records << new_data
    end
  end

  private

  def next_id
    records = self.class.load_records
    return 0 unless records
    records.map(&:id).max + 1
  end
end
