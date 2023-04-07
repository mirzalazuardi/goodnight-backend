class Api::V1::UsersController < ApplicationController
  before_action :authentication, except: :create
  before_action :set_follower_user_id, only: [:follow]

  def create
    raise RequiredFieldMissing.new(:name) if params.dig(:user,:name).blank?
    @user = User.new(user_params)
    if @user.save
      render jsonapi: @user
    else
      render jsonapi_errors: @user, status: :unprocessable_entity
    end
  end

  def follow
    @follower = Follower.new(follower_params)
    if @follower.save
      render jsonapi: @follower
    else
      render jsonapi_errors: @follower, status: :unprocessable_entity
    end
  end
  
  private

  def set_follower_user_id
    params[:follower][:user_id] = current_user.id
  end

  def user_params
    params.require(:user).permit(:name)
  end

  def follower_params
    params.require(:follower).permit(:user_id, :follower_id)
  end
end
