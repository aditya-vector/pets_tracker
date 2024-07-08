FactoryBot.define do
  factory :pet do
    type { %w[Dog Cat].sample }
    tracker_type { %w[small medium big].sample }
    owner_id { Faker::Number.number(digits: 5) }
    in_zone { false }
  end

  factory :dog, parent: :pet, class: 'Dog' do
    type { 'Dog' }
    tracker_type { %w[small medium big].sample }
  end

  factory :cat, parent: :pet, class: 'Cat' do
    type { 'Cat' }
    tracker_type { %w[small big].sample }
    lost_tracker { false }
  end
end
