class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login
  skip_before_action :verify_authenticity_token, only: [:login]

  # POST /auth/login
  # def login
  #   @user = User.find_by(email: login_params[:email])

  #   if @user&.authenticate(login_params[:password])
  #     token = JsonWebToken.encode(user_id: @user.id)
  #     exp_time = 24.hours.from_now

  #     render json: {
  #       token: token,
  #       exp: exp_time.strftime("%m-%d-%Y %H:%M"),
  #       username: @user.username
  #     }, status: :ok
  #   else
  #     render json: { error: 'Unauthorized' }, status: :unauthorized
  #   end
  # end

  def login
    @user = User.find_by_email(login_params[:email])
    if @user&.authenticate(login_params[:password])
      access_token = JsonWebToken.encode({ user_id: @user.id }, 15.minutes.from_now)
      refresh_token = JsonWebToken.encode({ user_id: @user.id, refresh: true }, 7.days.from_now)

      render json: {
        access_token: access_token,
        refresh_token: refresh_token,
        exp: 15.minutes.from_now.strftime("%m-%d-%Y %H:%M"),
        username: @user.username
      }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end


  private

  def login_params
    params.require(:authentication).permit(:email, :password)
  end
end
