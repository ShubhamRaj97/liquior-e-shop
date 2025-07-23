class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :index]
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    render json: UserSerializer.new(@users).serializable_hash, status: :ok
  end


  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  # POST /users

  def create
    role_ids = user_params[:role_ids]

    if role_ids.present?
      roles = Role.where(id: role_ids)
      if roles.size != role_ids.uniq.size
        return render json: { errors: ['One or more role_ids are invalid'] }, status: :unprocessable_entity
      end
    else
      return render json: { errors: ['role_ids are required'] }, status: :unprocessable_entity
    end

    @user = User.new(user_params.except(:role_ids))

    if @user.save
      @user.roles << roles
      render json: UserSerializer.new(@user)
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # PUT /users/{username}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/{username}
  def destroy
    @user.destroy
  end

  private

  def find_user
    @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit(
      :avatar, :name, :username, :email, :password, :password_confirmation, role_ids: []
    )
  end
end