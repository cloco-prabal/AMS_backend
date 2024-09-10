class ArtistsController < ApplicationController
  def index
    render json: Artist.all

  end

  def create
    artist = Artist.new(artist_params)
    if artist.save
      render json: artist, status: :created
    else
      render json: artist.errors, status: :unprocessable_entity
    end
  end



  def destroy
    Artist.find(params[:id]).destroy!
    head :no_content
  end

  private

  def artist_params
    params.require(:artist).permit(:name, :dob, :gender, :address, :first_release_year, :no_of_albums_released)
  end

end
