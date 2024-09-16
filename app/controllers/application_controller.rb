class ApplicationController < ActionController::API
    before_action :authorized
    rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed


    def encode_token(payload)
        JWT.encode(payload,  Rails.application.credentials[:secret_key_base],'HS256')
    end

    def decoded_token
        header = request.headers['Authorization']

        if header
            token = header.split(' ')[1]
            begin
                JWT.decode(token,Rails.application.credentials[:secret_key_base])
            rescue JWT::DecodeError => e
                Rails.logger.error("JWT Decode Error: #{e.message}")
                nil
            end
        end
    end

    def current_user
        if decoded_token
            user_id = decoded_token[0]['id']
            @user = User.find_by(id: user_id)
        end
    end

    def authorized
        unless !!current_user
            render json:{message: "Please log in"}, status: :unauthorized
        end
    end

    private

    def not_destroyed(e)
        render json: { error: e.record.errors }, status: :unprocessable_entity
    end
end
