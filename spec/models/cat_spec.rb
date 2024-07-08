require 'rails_helper'

RSpec.describe Cat, type: :model do
  describe 'validations' do
    it { should validate_inclusion_of(:tracker_type).in_array(%w[small big]) }
  end
end
