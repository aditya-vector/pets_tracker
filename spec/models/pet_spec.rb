require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:type) }
    it { should validate_inclusion_of(:type).in_array(%w[Dog Cat]) }
    it { should validate_presence_of(:tracker_type) }
  end
end
