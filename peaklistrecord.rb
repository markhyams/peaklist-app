class PeakListRecord
  class << self
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
    
    def order_by_str(sort_param, reverse)
      sort_names = self::VALID_SORTS.keys
      order_by = sort_names.include?(sort_param) ? sort_param : sort_names.first
      if self::REVERSE_SORTS.include?(sort_param)
        reverse = reverse == false
      end
  
      rev = reverse ? " DESC" : ""
      order_by + rev
    end

    
    def page_name
      to_s.downcase + "s"
    end
  end
end
