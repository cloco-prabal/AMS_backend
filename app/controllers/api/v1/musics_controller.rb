module Api
  module V1
class MusicsController < ApplicationController
  def index

    musics = Music.page(params[:page]||1).per(params[:pageSize]||10)
    render json: {
      data:musics,
      pagination:{
        current_page: musics.current_page,
        total_pages: musics.total_pages,
        total_count: musics.total_count
      }
    }

  end

  def create
    music = Music.new(music_params)

    if music.save
      render json: music, status: :created
    else
      render json: music.errors, status: :unprocessable_entity
    end
  end

  def update 
    music = Music.find_by(id:params[:id])

    if !music
      render json: {message:"No music found with given id"}
    else
      # return render json: music_params
      isUpdated = music.update(music_params)
      if isUpdated

        render json: {message:"Music updated successfully"}, status: :ok
      else
        render json: music.errors, status: :unprocessable_entity
      end
    end


  end

  def show
    music = Music.find_by(id:params[:id])
    if !music
      render json: {message:"No music found with given id"}, status: :not_found
    else
      render json:  music, status: :ok
    end
  end

  def getByArtistId
    musics = Music.where("artist_id=?",params[:artistId]).page(params[:page])
    .per(params[:pageSize] || 10)
    render json: {
      data: musics,
      pagination: {
        current_page: musics.current_page,
        total_pages: musics.total_pages,
        total_count: musics.total_count
      }
    }
  end

  def destroy
    Music.find(params[:id]).destroy!

    head :no_content
  end


 private

 def music_params
  params.require(:music).permit(:title, :album_name, :genre, :artist_id)

 end

end
end
end