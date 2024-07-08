class PetsController < ApplicationController
  def index
    @pets = PetsFilterGroupQuery.new(relation: Pet.all, params: params).call

    render json: { pets: @pets }
  end

  def create
    @pet = Pet.new(pet_params)

    if @pet.save
      render json: { pet: @pet }, status: :created
    else
      render json: @pet.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    @pet = Pet.find(params[:id])

    render json: { pet: @pet }
  end

  private

  def pet_params
    params.require(:pet).permit(:type, :tracker_type, :owner_id, :in_zone, :lost_tracker)
  end
end
