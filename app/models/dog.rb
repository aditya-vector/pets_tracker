class Dog < Pet
  validates :tracker_type, inclusion: { in: %w[small medium big] }

  # lost tracker is always false for dogs
  def lost_tracker=(_value)
    false
  end

  # TODO: use a serializer
  def as_json(options = {})
    super(options).except("lost_tracker")
  end
end
