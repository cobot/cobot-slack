class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate

  private

  def authenticate
    unless logged_in?
      session[:return_to] = request.url
      redirect_to root_path
    end
  end

  def logged_in?
    !!current_user
  end

  def current_user
    User.find session[:current_user_id] if session[:current_user_id]
  end

  def api_client(access_token)
    @api_client ||= CobotClient::ApiClient.new(access_token)
  end

  def show_header
    @show_header = true
  end
end
