class ApplicationController < ActionController::API
  include JSONAPI::Pagination

  attr_reader :current_user

  rescue_from RequiredFieldMissing, with: :bad_request
  rescue_from UnauthorizedAccess, with: :unauthorized_request
  rescue_from ActiveRecord::RecordNotFound, with: :no_record

  def authentication
    key = request.headers["key"]
    secret = request.headers["secret"]

    search = User.find_by key: key, secret: secret
    @current_user ||= search

    raise UnauthorizedAccess unless @current_user.present?

    @current_user
  end

  def bad_request(e)
    render json: {error: "Required field missing: #{e}"}, status: :bad_request
  end

  def unauthorized_request
    render json: {error: "unauthorized"}, status: :unauthorized
  end

  def no_record
    render json: {error: "no record"}, status: :not_found
  end
end
