class ApplicationController < ActionController::API
  rescue_from RequiredFieldMissing, with: :bad_request

  def bad_request(e)
    render json: {error: 'Required field missing: e'}
  end
end
