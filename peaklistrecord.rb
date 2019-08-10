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
  end
end
