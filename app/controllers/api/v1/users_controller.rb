module Api
  module V1

class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]
  def index
    sql_query = "SELECT id, first_name, last_name, email, address, gender, dob FROM users"
    @users = ActiveRecord::Base.connection.exec_query(sql_query)
    # Convert the result to an array of hashes
    users_array = @users.map do |row|
      {
        id: row['id'],
        first_name: row['first_name'],
        last_name: row['last_name'],
        email: row['email'],
        address: row['address'],
        gender: row['gender'],
        dob: row['dob']
      }
    end
  
    render json: users_array
  end

  def update
    user = User.find_by(params[:id]);
    userToUpdate = {"first_name"=>user_params[:first_name], "last_name"=>user_params[:last_name], "email"=>user_params[:email], "password"=>user_params[:password_digest], "phone"=>user_params[:phone], "dob"=>user_params[:dob], "gender"=>user_params[:gender], "address"=>user_params[:address],"role_id"=>user_params[:role_id]||1}
   isUpdated =  user.update(userToUpdate)
  
   if isUpdated
    render  json: user, status: :ok
  else
    render json:user.errors, status: :unprocessable_entity
  
   end

  end

  def create
  userToCreate = {"first_name"=>user_params[:first_name], "last_name"=>user_params[:last_name], "email"=>user_params[:email], "password"=>user_params[:password_digest], "phone"=>user_params[:phone], "dob"=>user_params[:dob], "gender"=>user_params[:gender], "address"=>user_params[:address],"role_id"=>user_params[:role_id]||1}
  user = User.new(userToCreate)
    if user.save
      render json: UserSerializer.new(user).as_json, status: :created
    else
      render json:user.errors, status: :unprocessable_entity
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
    params.require(:user).permit(:first_name, :last_name, :email, :password,:password_digest, :phone, :dob, :gender, :address,:role_id)
  end

end
end 
end