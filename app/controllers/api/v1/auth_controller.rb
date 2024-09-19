class Api::V1::AuthController < ApplicationController
    skip_before_action :authorized, only: [:login]
    skip_load_and_authorize_resource only: [:login]

    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found


    
    def login 
        @user = User.find_by!(email: login_params[:email])
        if @user&.authenticate(login_params[:password])
            @role = Role.find_by!(id:@user.role_id)
            @token = encode_token(id: @user.id)
            render json: {
                user: UserSerializer.new(@user).as_json,
                role:@role,
                token: @token

            }, status: :accepted
        else
            render json: {message: 'Incorrect password'}, status: :unauthorized
        end

    end


    private 

    def login_params 
        params.permit(:email, :password)
    end

    def handle_record_not_found(e)
        render json: { message: "User doesn't exist" }, status: :unauthorized
    end
end
