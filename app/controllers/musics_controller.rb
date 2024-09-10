class MusicsController < ApplicationController
  def index
    render json: Music.all

  end

  def create
    music = Music.new(music_params)

    if music.save
      render json: music, status: :created
    else
      render json: music.errors, status: :unprocessable_entity
    end
  end

  def destroy
    Music.find(params[:id]).destroy!

    head :no_content
  end


 private

 def music_params
  params.require(:music).permit(:title, :album_name, :genre)

 end

end
