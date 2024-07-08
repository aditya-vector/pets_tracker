class Pet < ApplicationRecord
  validates :type, presence: true, inclusion: { in: %w[Dog Cat] }
  validates :tracker_type, presence: true

  # TODO: use a serializer
  def as_json(options = {})
    super(options).merge(type: type)
  end
end
