
module Api
  module V1
  class ArtistsController < ApplicationController
  def index
    artists = Artist.order(id: :desc).page(params[:page]||1).per(params[:pageSize]||10)
    render json: {
      data:artists,
      pagination: {
        current_page: artists.current_page,
        total_pages: artists.total_pages,
        total_count: artists.total_count
      }
    }

  end

  def create
    artist = Artist.new(artist_params)
    if artist.save
      render json: artist, status: :created
    else
      render json: artist.errors, status: :unprocessable_entity
    end
  end

  def update
    artist = Artist.find_by(id:params[:id])
    if !artist
      render json:  {error: "Artist not found"}, status: :not_found
    else
      isUpdated = artist.update(artist_params)
      if isUpdated
        render json: {message: "Artist updated successfully"}, status: :ok
      else
        render  json: artist.errors, status: :unprocessable_entity

      end

    end

  end

  def show
    artist = Artist.find_by(id:params[:id])
    if !artist
      render json: {message:"No artist found with given id"}, status: :not_found
    else
      render json:  artist, status: :ok
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
  end 
end