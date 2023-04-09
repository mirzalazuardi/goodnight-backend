class Api::V1::UsersController < ApplicationController
  before_action :authentication,
    only: [:follow, :unfollow, :sleep_records, :display_sleep_records,
           :friends_sleep_records]
  before_action :set_follower_user_id, only: [:follow]
  before_action :set_follower_follower_id, only: [:unfollow]

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

  def unfollow
    @follower = Follower.find_by(follower_params)
    raise ActiveRecord::RecordNotFound if @follower.nil?
    @follower.destroy
    if @follower.destroyed?
      render jsonapi: @follower
    else
      render jsonapi_errors: @follower, status: :unprocessable_entity
    end
  end

  def sleep_records
    @sleep = Sleep.clock(current_user.id)
    if @sleep
      render jsonapi: Sleep.where(user: current_user).last
    else
      render jsonapi: @sleep
    end
  end

  def display_sleep_records
    @sleeps = Sleep.completed(current_user.id)
    render jsonapi: @sleeps
  end

  def friends_sleep_records
    @sleeps = Sleep.friends_sleeps(current_user.id)
    render jsonapi: @sleeps
  end

  private

  def set_follower_follower_id
    params[:follower][:follower_id] = current_user.id
  end

  def set_follower_user_id
    params[:follower][:user_id] = current_user.id
  end

  def user_params
    params.require(:user).permit(:name)
  end

  def follower_params
    params.require(:follower).permit(:user_id, :follower_id)
  end

  def jsonapi_meta(resources)
    pagination = jsonapi_pagination_meta(resources)

    {}.tap do |h|
      h[:total] = resources.count if resources.respond_to?(:count)
      h[:pagination] = pagination if pagination.present?
    end
  end
end
