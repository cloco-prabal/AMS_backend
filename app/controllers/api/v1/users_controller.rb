module Api
  module V1

class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]
  skip_load_and_authorize_resource only: :create

  def index
    
    users = User.order(id: :desc).page(params[:page]||1).per(params[:pageSize]||10)
    render json: {
      data:users.as_json(include: :role),
      pagination:{
        current_page: users.current_page,
        total_pages: users.total_pages,
        total_count: users.total_count
      }
    }
  
  end

  def update
    user = User.find_by(id:params[:id]);

    userToUpdate = {"first_name"=>user_params[:first_name], "last_name"=>user_params[:last_name], "email"=>user_params[:email], "password"=>user_params[:password_digest], "phone"=>user_params[:phone], "dob"=>user_params[:dob], "gender"=>user_params[:gender], "address"=>user_params[:address],"role_id"=>user_params[:role_id]||1,"artist_id"=>user_params[:artist_id]}


    isUpdated =  user.update(userToUpdate)
  
   if isUpdated
    render  json: user, status: :ok
  else
    render json:user.errors, status: :unprocessable_entity
  
   end

  end

  def create
    userToCreate = {"first_name"=>user_params[:first_name], "last_name"=>user_params[:last_name], "email"=>user_params[:email], "password"=>user_params[:password_digest], "phone"=>user_params[:phone], "dob"=>user_params[:dob], "gender"=>user_params[:gender], "address"=>user_params[:address],"role_id"=>user_params[:role_id]||1,"artist_id"=>user_params[:artist_id]||""}
      
    user = User.new(userToCreate)
      if user.save
        render json: UserSerializer.new(user).as_json, status: :created
      else
        render json:user.errors, status: :unprocessable_entity
      end
  
  end

  def show
    user = User.find_by(id:params[:id])
    if !user
      render json: {message:"No user found with given id"}, status: :not_found
    else
      render json:  UserSerializer.new(user).as_json, status: :ok
    end
  end

  def me 
    render json: current_user, status: :ok
  end

  def destroy
    User.find(params[:id]).destroy!
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :artist_id, :last_name, :email, :password,:password_digest, :phone, :dob, :gender, :address,:role_id)
  end

end
end 
end