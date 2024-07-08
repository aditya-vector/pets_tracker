class FilterGroupQuery
  def initialize(relation:, params:)
    @relation = relation
    @params = params
  end

  def call
    results = apply_filters(@relation)
    results = apply_grouping(results) if @params[:group_by].present?
    results
  end

  private

  def apply_filters(results)
    sanitized_filter_params.each do |column, value|
      results = @relation.where(column => value)
    end
    results
  end

  def apply_grouping(results)
    if group_columns = sanitized_group_columns(@params[:group_by]).presence
      results = results.group(*group_columns)
      format_grouped_data(results.count)
    else
      results
    end
  end

  # Format the grouped data into nested hashes
  # Example Input: {["Cat", "big"]=>2, ["Cat", "small"]=>2, ["Dog", "big"]=>2, ["Dog", "small"]=>3}
  # Example Output: {"Cat"=>{"big"=>2, "small"=>2}, "Dog"=>{"big"=>2, "small"=>3}}
  # Currently only supports grouping by 2 columns
  def format_grouped_data(grouped_data)
    grouped_data.each_with_object({}) do |(keys, count), hash|
      hash[keys.first] ||= {}
      hash[keys.first][keys.last] = count
    end
  end
end
