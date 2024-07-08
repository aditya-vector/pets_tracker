require 'rails_helper'

RSpec.describe Dog, type: :model do
  describe 'validations' do
    it { should validate_inclusion_of(:tracker_type).in_array(%w[small medium big]) }
  end

  describe '#lost_tracker=' do
    it 'returns false' do
      dog = Dog.new(lost_tracker: true)
      expect(dog.lost_tracker).to eq(false)
    end
  end
end
