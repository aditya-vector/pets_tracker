class Cat < Pet
  validates :type, presence: true, inclusion: { in: %w[Dog Cat] }
  validates :tracker_type, presence: true, inclusion: { in: %w[small big] }
end
