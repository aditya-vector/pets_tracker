class PetsFilterGroupQuery < FilterGroupQuery

  GROUP_COLUMNS = %w[type tracker_type].freeze
  FILTER_COLUMNS = %w[in_zone lost_tracker owner_id type tracker_type].freeze

  private

  def sanitized_group_columns(group_by)
    group_by.split(',').select { |column| GROUP_COLUMNS.include?(column) }
  end

  def sanitized_filter_params
    @params.slice(*FILTER_COLUMNS)
  end
end
