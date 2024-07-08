require 'rails_helper'

RSpec.describe "Pets", type: :request do
  describe "POST /pets" do
    describe 'Dog' do
      context 'with valid parameters' do
        it 'creates a new pet' do
          expect {
            post '/pets', params: {
              pet: {
                type: 'Dog',
                tracker_type: 'small',
                owner_id: 12345,
              }
            }, as: :json
          }.to change(Dog, :count).by(1)
          expect(response).to have_http_status(:created)
          response_body = JSON.parse(response.body)
          expect(response_body['pet']['type']).to eq('Dog')
          expect(response_body['pet']['tracker_type']).to eq('small')
          expect(response_body['pet']['owner_id']).to eq(12345)
          expect(response_body['pet']['in_zone']).to eq(true)
          expect(response_body['pet'].has_key?('lost_tracker')).to eq(false)
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          expect {
            post '/pets', params: {
              pet: {
                type: 'Dog',
                tracker_type: 'huge',
                owner_id: 12345,
                in_zone: false,
                lost_tracker: false
              }
            }
          }.to change(Dog, :count).by(0)
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.body).to include('Tracker type is not included in the list')
        end
      end
    end

    describe 'Cat' do
      context 'with valid parameters' do
        it 'creates a new pet' do
          expect {
            post '/pets', params: {
              pet: {
                type: 'Cat',
                tracker_type: 'big',
                owner_id: 12345,
                in_zone: true,
                lost_tracker: false,
              }
            }, as: :json
          }.to change(Cat, :count).by(1)
          expect(response).to have_http_status(:created)
          response_body = JSON.parse(response.body)
          expect(response_body['pet']['type']).to eq('Cat')
          expect(response_body['pet']['tracker_type']).to eq('big')
          expect(response_body['pet']['owner_id']).to eq(12345)
          expect(response_body['pet']['in_zone']).to eq(true)
          expect(response_body['pet'].has_key?('lost_tracker')).to eq(true)
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          expect {
            post '/pets', params: {
              pet: {
                type: 'Cat',
                tracker_type: 'medium',
                owner_id: 12345,
                in_zone: false,
                lost_tracker: false
              }
            }
          }.to change(Cat, :count).by(0)
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.body).to include('Tracker type is not included in the list')
        end
      end
    end
  end

  describe "GET /pets/:id" do
    describe 'Dog' do
      it 'returns a pet' do
        dog = FactoryBot.create(:dog)
        get "/pets/#{dog.id}"
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['pet']['type']).to eq('Dog')
        expect(response_body['pet']['tracker_type']).to eq(dog.tracker_type)
        expect(response_body['pet']['owner_id']).to eq(dog.owner_id)
        expect(response_body['pet']['in_zone']).to eq(dog.in_zone)
        expect(response_body['pet'].has_key?('lost_tracker')).to eq(false)
      end

      it 'returns a 404 status if the pet does not exist' do
        get '/pets/12345'
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'Cat' do
      it 'returns a pet' do
        cat = FactoryBot.create(:cat)
        get "/pets/#{cat.id}"
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['pet']['type']).to eq('Cat')
        expect(response_body['pet']['tracker_type']).to eq(cat.tracker_type)
        expect(response_body['pet']['owner_id']).to eq(cat.owner_id)
        expect(response_body['pet']['in_zone']).to eq(cat.in_zone)
        expect(response_body['pet'].has_key?('lost_tracker')).to eq(true)
      end

      it 'returns a 404 status if the pet does not exist' do
        get '/pets/12345'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /pets" do
    describe 'filtering' do
      it 'returns a list of pets filtered by type' do
        FactoryBot.create(:dog)
        FactoryBot.create(:cat)
        get '/pets?type=Dog'
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['pets'].size).to eq(1)
        expect(response_body['pets'].first['type']).to eq('Dog')
      end

      it 'returns a list of pets filtered by tracker_type' do
        FactoryBot.create(:dog, tracker_type: 'small')
        FactoryBot.create(:dog, tracker_type: 'big')
        get '/pets?tracker_type=small'
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['pets'].size).to eq(1)
        expect(response_body['pets'].first['tracker_type']).to eq('small')
      end

      it 'returns a list of pets filtered by owner_id' do
        FactoryBot.create(:dog, owner_id: 12345)
        FactoryBot.create(:dog, owner_id: 54321)
        get '/pets?owner_id=12345'
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['pets'].size).to eq(1)
        expect(response_body['pets'].first['owner_id']).to eq(12345)
      end

      it 'returns a list of pets filtered by in_zone' do
        FactoryBot.create(:dog, in_zone: true)
        FactoryBot.create(:dog, in_zone: false)
        get '/pets?in_zone=true'
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['pets'].size).to eq(1)
        expect(response_body['pets'].first['in_zone']).to eq(true)
      end

      it 'returns a list of pets filtered by lost_tracker' do
        FactoryBot.create(:cat, lost_tracker: true)
        FactoryBot.create(:cat, lost_tracker: false)
        get '/pets?lost_tracker=true'
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['pets'].size).to eq(1)
        expect(response_body['pets'].first['lost_tracker']).to eq(true)
      end
    end

    describe 'grouping and filtering' do
      it 'returns a count of pets outside the power saving zone grouped by pet type and tracker type' do
        FactoryBot.create_list(:dog, 2, in_zone: false, tracker_type: 'small')
        FactoryBot.create(:dog, in_zone: false, tracker_type: 'medium')
        FactoryBot.create_list(:dog, 3, in_zone: false, tracker_type: 'big')
        FactoryBot.create(:cat, in_zone: false, tracker_type: 'big')
        FactoryBot.create_list(:cat, 2, in_zone: false, tracker_type: 'small')


        get '/pets?in_zone=false&group_by=type,tracker_type'
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['pets']["Dog"]["small"]).to eq(2)
        expect(response_body['pets']["Dog"]["medium"]).to eq(1)
        expect(response_body['pets']["Dog"]["big"]).to eq(3)
        expect(response_body['pets']["Cat"]["small"]).to eq(2)
        expect(response_body['pets']["Cat"]["big"]).to eq(1)
      end
    end

    it 'returns a list of pets' do
      FactoryBot.create_list(:cat, 3)
      get '/pets'
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body['pets'].size).to eq(3)
      expect(response_body['pets'].first['type']).to eq('Cat')
      expect(response_body['pets'].first.has_key?('tracker_type')).to eq(true)
      expect(response_body['pets'].first.has_key?('owner_id')).to eq(true)
      expect(response_body['pets'].first.has_key?('in_zone')).to eq(true)
      expect(response_body['pets'].first.has_key?('lost_tracker')).to eq(true)
    end
  end
end
