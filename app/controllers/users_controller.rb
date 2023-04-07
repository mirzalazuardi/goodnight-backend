class UsersController < ApplicationController
  def create
    raise RequiredFieldMissing.new(:name) if params[:name].blank?

    @user = User.new(name: params[:name])
    if @user.save
      render jsonapi: @user
    else
      render jsonapi_errors: @user, status: :unprocessable_entity
    end
  end
end
